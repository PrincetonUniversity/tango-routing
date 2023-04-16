"""Control plane implementation for stress test."""

import logging
import os
import sys
from argparse import ArgumentParser
from dataclasses import dataclass
from datetime import datetime, timedelta
from enum import Enum
from hashlib import sha256
from pathlib import Path
from pickle import dump as pickle
from pickle import load as unpickle
from time import sleep
from typing import Any, List, Optional

PY_VERSION = f"{str(sys.version_info.major)}.{str(sys.version_info.minor)}"
sys.path.append(os.path.expandvars(f"$SDE/install/lib/python{PY_VERSION}/site-packages/tofino/"))
sys.path.append(
    os.path.expandvars(f"$SDE/install/lib/python{PY_VERSION}/site-packages/tofino/bfrt_grpc/"),
)

import bfrt_grpc.client as gc


logging.basicConfig(level=logging.INFO)


@dataclass
class PrecomputedSignatures:
    """All precomputed signatures."""

    timestamp_signatures: List[int]
    sequence_num_signatures: List[int]


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

    TIMESTAMP_SIGS = "pipe.outgoing_metric_signature_manager_0"
    SEQ_NUM_SIGS = "pipe.outgoing_book_signature_manager_0"


class Table:
    """Wrapper around Tofino table interface."""

    def __init__(self: "Table", name: TableName, client: TofinoRuntimeClient) -> None:
        """Create an alias to interact with a table."""
        self._table = client.runtime_info.table_dict[name.value]

    def add_entry(
        self: "Table",
        key: gc.KeyTuple,
        data: gc.DataTuple,
    ) -> None:
        """Add key-date entries to table."""
        keys = self._table.make_key([key])
        datums = self._table.make_data([data])
        self._table.entry_add(
            target=gc.Target(),
            key_list=[keys],
            data_list=[datums],
        )

    def add_bulk_entry(
        self: "Table",
        key_list: List[gc.KeyTuple],
        data_list: List[gc.DataTuple],
    ) -> None:
        """Add key-date entries to table."""
        keys = [self._table.make_key([key]) for key in key_list]
        datums = [self._table.make_data([datum]) for datum in data_list]
        self._table.entry_add(
            target=gc.Target(),
            key_list=keys,
            data_list=datums,
        )

    def get_entry(
        self: "Table",
        key: gc.KeyTuple,
    ) -> Any:  # noqa: ANN401
        """Add key-date entries to table."""
        keys = self._table.make_key([key])
        return self._table.entry_get(
            target=gc.Target(),
            key_list=[keys],
        )

    def get_bulk_entry(
        self: "Table",
        key_list: List[gc.KeyTuple],
    ) -> Any:  # noqa: ANN401
        """Add key-date entries to table."""
        keys = [self._table.make_key([key]) for key in key_list]
        return self._table.entry_get(
            target=gc.Target(),
            key_list=keys,
        )


def start_controller(signature_file: Path) -> None:
    """Populate the Tofino with precomputed signatures."""
    logger = logging.getLogger(__name__)
    refresh_cycle_period = timedelta(milliseconds=16)
    refresh_ms = refresh_cycle_period.microseconds // 1000
    seq_sigs_refresh_per_cycle = 1000  # 9766 * refresh_ms  # NOTE: 1280 byte pkts -> 9766 pkts / ms

    if len(sys.argv) != 2:
        logger.error("Usage: <program> <pickle-filepath>")
        sys.exit(1)

    pickle_filename = signature_file.absolute()
    logger.info("Reading pickled signatures @ file://%s ...", str(pickle_filename))
    with pickle_filename.open("rb") as file:
        unpickled_data: PrecomputedSignatures = unpickle(file)  # noqa: S301

    with TofinoRuntimeClient() as client:
        ts_table = Table(TableName.TIMESTAMP_SIGS, client=client)
        seq_num_table = Table(TableName.SEQ_NUM_SIGS, client=client)

        try:
            count = 0
            while count < 2:
                timestart = datetime.now()  # noqa: DTZ005

                logger.info("Refreshing signature values...")

                register_index_key = "$REGISTER_INDEX"
                ts_sig_field_name = "outgoing_metric_signature_manager_0.f1"
                seq_num_field_name = "outgoing_book_signature_manager_0.f1"

                keys_ts = [
                    gc.KeyTuple(name=register_index_key, value=idx)
                    for idx in range(
                        (count % 2) * refresh_ms,
                        ((count % 2) * refresh_ms) + refresh_ms,
                    )
                ]

                datums_ts = [
                    gc.DataTuple(name=ts_sig_field_name, val=val)
                    for val in unpickled_data.timestamp_signatures[
                        (count * refresh_ms) : ((count * refresh_ms) + refresh_ms)
                    ]
                ]

                keys_seq = [
                    gc.KeyTuple(name=register_index_key, value=idx)
                    for idx in range(
                        (count % 8) * seq_sigs_refresh_per_cycle,
                        ((count % 8) * seq_sigs_refresh_per_cycle) + seq_sigs_refresh_per_cycle,
                    )
                ]

                datums_seq = [
                    gc.DataTuple(name=seq_num_field_name, val=val)
                    for val in unpickled_data.sequence_num_signatures[
                        (count * seq_sigs_refresh_per_cycle) : (
                            (count * seq_sigs_refresh_per_cycle) + seq_sigs_refresh_per_cycle
                        )
                    ]
                ]

                ts_table.add_bulk_entry(keys_ts, datums_ts)
                seq_num_table.add_bulk_entry(keys_seq, datums_seq)

                count = count + 1
                timeend = datetime.now()  # noqa: DTZ005
                runtime = timeend - timestart
                logger.info("Finished refresh cycle in %f ms...", runtime.total_seconds() * 1000)
                sleeptime = (refresh_cycle_period - runtime).total_seconds()
                sleep(sleeptime if sleeptime > 0 else 0)
        except KeyboardInterrupt:
            logger.info("Caught user interrupt... Gracefully exciting...")
            sys.exit(0)


def hash_int(num: int) -> int:
    """Hash an int into a 32-bit integer."""
    return int.from_bytes(
        sha256(num.to_bytes((num.bit_length() + 7) // 8, "big")).digest()[-4:],
        "big",
    )


def compute_timestamp_signatures(test_length: timedelta) -> list[int]:
    """Generate signaures for all timestamps."""
    num_signaures_needed = test_length // timedelta(milliseconds=1)
    return [hash_int(i) for i in range(0, num_signaures_needed)]


def compute_sequence_num_signatures(num_seq_nums: int) -> list[int]:
    """Generate signaures for all sequence numbers."""
    return [hash_int(i) & 1 for i in range(0, num_seq_nums)]


def pickle_signatures(filename: Path, ts_sigs: list[int], seq_sigs: list[int]) -> None:
    """Pickle the precomputed signatures."""
    with filename.open("wb") as file:
        pickle(
            PrecomputedSignatures(timestamp_signatures=ts_sigs, sequence_num_signatures=seq_sigs),
            file,
        )


def start_signature_computation(signature_file: Path) -> None:
    """Genreate pickle file containing all precomputed signatures."""
    filepath = signature_file.absolute()

    test_time_len = timedelta(minutes=1)
    packets_per_seq_book = 2 ** 16
    num_books = 512
    num_seq_sigs = packets_per_seq_book * num_books

    timestamp_sigs = compute_timestamp_signatures(test_time_len)
    seq_num_sigs = compute_sequence_num_signatures(num_seq_sigs)

    pickle_signatures(filepath, ts_sigs=timestamp_sigs, seq_sigs=seq_num_sigs)
    print(f"\n-- SUCCESS --\n\nPickled signatures @ file://{filepath}")  # noqa: T201


def create_cli_parser() -> ArgumentParser:
    """Create a cli parser for control plane interaction."""
    parser = ArgumentParser(description="Tango control plane cli.")
    subparsers = parser.add_subparsers(help="Subcommands")

    controller = subparsers.add_parser(
        "control",
        description="Interact with the control plane on the Tofino.",
    )
    controller.add_argument(
        "-f",
        "--file",
        dest="pickled_file",
        required=True,
        nargs=1,
        type=Path,
        help="Path to file containing precomputed signatures.",
    )

    precompute = subparsers.add_parser(
        "precompute",
        description="Interact with precomputation of crytographic signatures.",
    )
    precompute.add_argument(
        "-f",
        "--file",
        dest="file_to_pickle",
        required=True,
        nargs=1,
        type=Path,
        help="Path to file to dump precomputed signatures.",
    )

    return parser


def main() -> None:
    """Cli to gernerate signatures and write them to the Tofino at runtime."""
    parser = create_cli_parser()
    args = vars(parser.parse_args())

    if controller_file := args.get("pickled_file"):
        start_controller(controller_file[0])
    elif precompute_file := args.get("file_to_pickle"):
        start_signature_computation(precompute_file[0])
    else:
        parser.print_usage()


if __name__ == "__main__":
    main()
