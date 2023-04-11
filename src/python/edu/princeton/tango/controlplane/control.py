"""Control plane implementation for stress test."""

import logging
from enum import StrEnum
from typing import Any, Self

import bfrt_grpc.client as gc

logging.basicConfig(level=logging.INFO)


class TofinoRuntimeClient:
    """Wrapper around bfrt gRPC client."""

    def __init__(
        self: Self,
        grpc_addr: str | None = None,
        client_id: int | None = None,
    ) -> None:
        """Create a wrapper gRPC runtime client."""
        self._grpc_addr = grpc_addr or "localhost:50052"
        self._client_id = client_id or 0
        self._client: Any = None
        self._bfrt_info: Any = None
        self._logger = logging.getLogger(__name__)

    @property
    def runtime_info(self: Self) -> Any:  # noqa: ANN401
        """Runtime context."""
        return self._bfrt_info

    def __enter__(self: Self) -> Self:
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

    def __exit__(self: Self, _, __, ___):  # noqa: ANN204, ANN001, RUF100
        """Close gRPC connection."""
        del self._client
        self._logger.info("Closed connection to BF Runtime Server on client %d...", self._client_id)

    def reset_tables(self: Self) -> None:
        """Destroy all table entries."""
        self._client.clear_all_tables()


class TableName(StrEnum):
    """All tables in p4 program of note."""

    TIMESTAMP_SIGS = "pipe.outgoing_metric_signature_manager_0"
    SEQ_NUM_SIGS = "pipe.outgoing_book_signature_manager_0"


class ActionName(StrEnum):
    """Actions available for tables."""

    UNKNOWN = "INDEX"  # FIXME: heh?


class Table:
    """Wrapper around Tofino table interface."""

    def __init__(self: Self, name: TableName, client: TofinoRuntimeClient) -> None:
        """Create an alias to interact with a table."""
        self._table = client.runtime_info.table_dict[name.value]

    def add_entry(
        self: Self,
        key_list: list[gc.KeyTuple],
        data_list: list[gc.DataTuple],
        action_name: ActionName,
    ) -> None:
        """Add key-date entries to table."""
        keys = self._table.make_key(key_list)
        datums = self._table.make_data(data_list, action_name=action_name.value)
        self._table.entry_add(
            target=gc.Target(),
            key_list=[keys],
            data_list=[datums],
        )  # FIXME: Why is this a list? Can we set many / Batch requests?


def main() -> None:
    """I don't know what I am doing... just guessing here..."""
    with TofinoRuntimeClient() as client:
        ts_table = Table(TableName.TIMESTAMP_SIGS, client=client)
        seq_num_table = Table(TableName.SEQ_NUM_SIGS, client=client)

        # FIXME: Replace with pickled values.
        match_key_names = []
        match_key_vals = []

        action_data_names = []
        action_data_vals = []

        keys = [
            gc.KeyTuple(name=name, value=val)
            for name, val in zip(match_key_names, match_key_vals, strict=True)
        ]

        datums = [
            gc.DataTuple(name=name, val=val)
            for name, val in zip(action_data_names, action_data_vals, strict=True)
        ]

        # FIXME: dummy calls
        ts_table.add_entry(keys, datums, ActionName.UNKNOWN)
        seq_num_table.add_entry(keys, datums, ActionName.UNKNOWN)


if __name__ == "__main__":
    main()
