"""Gather signature write time metrics."""

import logging
import os
import sys
from enum import Enum
from typing import Any, List, Optional

PY_VERSION = f"{str(sys.version_info.major)}.{str(sys.version_info.minor)}"
sys.path.append(os.path.expandvars(f"$SDE/install/lib/python{PY_VERSION}/site-packages/tofino/"))
sys.path.append(
    os.path.expandvars(f"$SDE/install/lib/python{PY_VERSION}/site-packages/tofino/bfrt_grpc/"),
)

import bfrt_grpc.client as gc


logging.basicConfig(level=logging.INFO)


class TofinoRuntimeClient:
    """Wrapper around bfrt gRPC client."""

    def __init__(
        self: "TofinoRuntimeClient",
        grpc_addr: Optional[str] = None,
        client_id: Optional[int] = None,
    ) -> None:
        """Create a wrapper gRPC runtime client."""
        self._grpc_addr = grpc_addr or "localhost:50052"
        self._client_id = client_id or 0
        self._client: Any = None
        self._bfrt_info: Any = None
        self._logger = logging.getLogger(__name__)

    @property
    def runtime_info(self: "TofinoRuntimeClient") -> Any:  # noqa: ANN401
        """Runtime context."""
        return self._bfrt_info

    def __enter__(self: "TofinoRuntimeClient") -> "TofinoRuntimeClient":
        """Open gRPC Connection."""
        self._client = gc.ClientInterface(
            grpc_addr=self._grpc_addr,
            client_id=self._client_id,
            device_id=0,
            num_tries=1,
        )

        self._bfrt_info = self._client.bfrt_info_get(p4_name=None)

        if self._client_id == 0:
            self._client.bind_pipeline_config(self._bfrt_info.p4_name)

        self._logger.info("Connected to BF Runtime Server as client %d...", self._client_id)

        return self

    def __exit__(self: "TofinoRuntimeClient", _, __, ___):  # noqa: ANN204, ANN001, RUF100
        """Close gRPC connection."""
        del self._client
        self._logger.info("Closed connection to BF Runtime Server on client %d...", self._client_id)

    def reset_tables(self: "TofinoRuntimeClient") -> None:
        """Destroy all table entries."""
        self._client.clear_all_tables()


class TableName(Enum):
    """All tables in p4 program of note."""

    TIMESTAMP_SIGS_BLK0 = "pipe.outgoing_metric_signature_manager_0"
    TIMESTAMP_SIGS_BLK1 = "pipe.outgoing_metric_signature_manager_1"
    SEQ_NUM_SIGS_BLK0 = "pipe.outgoing_book_signature_manager_0"
    SEQ_NUM_SIGS_BLK1 = "pipe.outgoing_book_signature_manager_1"
    ROUTE_MANAGER = "pipe.route_manager_0"
    PACKET_WRITE_TIMES = "pipe.pkt_finish_times"
    START_TIME = "pipe.start_time"


class Table:
    """Wrapper around Tofino table interface."""

    def __init__(self: "Table", name: TableName, client: TofinoRuntimeClient) -> None:
        """Create an alias to interact with a table."""
        self._table = client.runtime_info.table_dict[name.value]

    def create_key(self: "Table", keyname: str, value: int) -> Any:  # noqa: ANN401
        """Create a single key to match into a table with."""
        return self._table.make_key([gc.KeyTuple(name=keyname, value=value)])

    def create_bulk_key(self: "Table", keyname: str, values: List[int]) -> List[Any]:
        """Create multiple keys to match into a table with for same keytype."""
        return [self._table.make_key([gc.KeyTuple(name=keyname, value=val)]) for val in values]

    def create_data_entry(self: "Table", fieldname: str, value: int) -> Any:  # noqa: ANN401
        """Create a data entry to action on the table entry with."""
        return self._table.make_data([gc.DataTuple(name=fieldname, val=value)])

    def create_bulk_data_entry(self: "Table", fieldname: str, values: List[int]) -> List[Any]:
        """Create a bulk data entry to action on the table entry on same fieldname."""
        return [self._table.make_data([gc.DataTuple(name=fieldname, val=val)]) for val in values]

    def add_entry(
        self: "Table",
        key: Any,  # noqa: ANN401
        data: Any,  # noqa: ANN401
    ) -> None:
        """Add key-date entries to table."""
        self._table.entry_add(
            target=gc.Target(),
            key_list=[key],
            data_list=[data],
        )

    def add_bulk_entry(
        self: "Table",
        keys: List[Any],
        data_entries: List[Any],
    ) -> None:
        """Add key-date entries to table."""
        self._table.entry_add(
            target=gc.Target(),
            key_list=keys,
            data_list=data_entries,
        )

    def get_entry(
        self: "Table",
        key: Any,  # noqa: ANN401
    ) -> Any:  # noqa: ANN401
        """Add key-date entries to table."""
        return self._table.entry_get(
            target=gc.Target(),
            key_list=key,
        )

    def get_bulk_entry(
        self: "Table",
        keys: List[Any],
    ) -> Any:  # noqa: ANN401
        """Add key-date entries to table."""
        return self._table.entry_get(
            target=gc.Target(),
            key_list=keys,
        )


def main() -> None:
    """Populate the switch with route updates and test they were successful."""
    logger = logging.getLogger(__name__)

    logger.info("Connecting to gRPC server...")
    with TofinoRuntimeClient() as client:
        start_time_tbl = Table(TableName.START_TIME, client=client)
        pkt_write_times_tbl = Table(TableName.PACKET_WRITE_TIMES, client=client)

        logger.info("Scraping start time...")

        start_time_key = start_time_tbl.create_bulk_key(
            keyname="$REGISTER_INDEX",
            values=[0],
        )

        scraped_start_time = -1
        for data, _ in start_time_tbl.get_bulk_entry(start_time_key):
            for start in data.to_dict()["start_time.f1"]:
                if start:
                    scraped_start_time = start

        print("--- TRIAL START ---")  # noqa: T201
        print("--- START TIME ---")  # noqa: T201
        print(f"Start Time: {scraped_start_time}")  # noqa: T201

        logger.info("Scraping timestamps...")

        pkt_timing_keys = pkt_write_times_tbl.create_bulk_key(
            keyname="$REGISTER_INDEX",
            values=list(range(0, 127)),
        )

        raw_scraped_pkt_times = pkt_write_times_tbl.get_bulk_entry(pkt_timing_keys)

        pkt_times = []
        for data, _ in raw_scraped_pkt_times:
            tses = data.to_dict()["pkt_finish_times.f1"]
            for ts in tses:
                if ts:
                    pkt_times.append(ts)

        times = sorted(pkt_times, reverse=True)

        print("-- Finish Timestamps --")  # noqa: T201
        for ts in times:
            print(ts)  # noqa: T201

        print("-- Runtime --")  # noqa: T201
        print(f"{times[0] - scraped_start_time} ms")  # noqa: T201
        print(f"--> {times[0]} (end) - {scraped_start_time} (start)")  # noqa: T201

        logger.info("Resetting registers...")

        start_time_reset = start_time_tbl.create_bulk_data_entry(
            fieldname="start_time.f1", values=[-1],
        )

        pkt_timings_reset = pkt_write_times_tbl.create_bulk_data_entry(
            fieldname="pkt_finish_times.f1", values=[0 for _ in range(0, 127)],
        )

        start_time_tbl.add_bulk_entry(start_time_key, start_time_reset)
        pkt_write_times_tbl.add_bulk_entry(pkt_timing_keys, pkt_timings_reset)

        print("--- TRIAL END ---")  # noqa: T201

        logger.info("Exiting...")


if __name__ == "__main__":
    main()
