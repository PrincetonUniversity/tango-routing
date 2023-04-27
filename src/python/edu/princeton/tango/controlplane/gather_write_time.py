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
    PACKET_WRITE_TIMES = "pkt_finish_times"


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
        seq_table_block0 = Table(TableName.SEQ_NUM_SIGS_BLK0, client=client)
        ts_table_blk0 = Table(TableName.TIMESTAMP_SIGS_BLK0, client=client)
        seq_table_block1 = Table(TableName.SEQ_NUM_SIGS_BLK1, client=client)
        ts_table_blk1 = Table(TableName.TIMESTAMP_SIGS_BLK1, client=client)

        logger.info("Attempting to fetch seq num block 0 signatures...")

        seq_keys0 = seq_table_block0.create_bulk_key(
            keyname="$REGISTER_INDEX",
            values=list(range(0, 4)),
        )

        seq_entries0 = seq_table_block0.get_bulk_entry(seq_keys0)

        for data, key in seq_entries0:
            logger.info("%s -> %s", str(key.to_dict()), str(data.to_dict()))

        logger.info("Attempting to fetch seq num block 1 signatures...")

        seq_keys1 = seq_table_block1.create_bulk_key(
            keyname="$REGISTER_INDEX",
            values=list(range(4, 8)),
        )

        seq_entries1 = seq_table_block1.get_bulk_entry(seq_keys1)

        for data, key in seq_entries1:
            logger.info("%s -> %s", str(key.to_dict()), str(data.to_dict()))

        logger.info("Attempting to fetch timestamp block 0 signatures...")

        ts_keys0 = ts_table_blk0.create_bulk_key(
            keyname="$REGISTER_INDEX",
            values=list(range(0, 4)),
        )

        ts_entries0 = ts_table_blk0.get_bulk_entry(ts_keys0)

        for data, key in ts_entries0:
            logger.info("%s -> %s", str(key.to_dict()), str(data.to_dict()))

        logger.info("Attempting to fetch timestamp block 1 signatures...")

        ts_keys1 = ts_table_blk1.create_bulk_key(
            keyname="$REGISTER_INDEX",
            values=list(range(4, 8)),
        )

        ts_entries1 = ts_table_blk1.get_bulk_entry(ts_keys1)

        for data, key in ts_entries1:
            logger.info("%s -> %s", str(key.to_dict()), str(data.to_dict()))

        logger.info("Exiting...")


if __name__ == "__main__":
    main()
