"""Models of events for Tango."""
from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum
from test.models.error import ModelError
from test.models.tango_types import EthernetHeader, FiveTuple, IPv4Header, IPv6Header, TangoHeader
from typing import Self


class InterpreterEvent(ABC):
    """Event for the Lucid interpreter."""

    __test__ = False

    @property
    @abstractmethod
    def name(self: Self) -> str:
        """Get the name of the event."""

    @abstractmethod
    def as_dict(
        self: Self,
    ) -> dict[str, int | str | list[int | str] | dict[int | str | list[int | str]]]:
        """Get dictionary representation of an interpreter event."""


class TangoEvent(InterpreterEvent):
    """A Tango event which can be tested."""


class ControlEvent(InterpreterEvent):
    """Command that the control plane can interact with registers."""


@dataclass
class ForwardFlow(TangoEvent):
    """Forward Flow event type."""

    eth_header: EthernetHeader
    ip_header: IPv4Header
    five_tuple: FiveTuple

    @property
    def name(self: Self) -> str:
        """Get the name of the event."""
        return "forward_flow"

    def as_dict(self: Self) -> dict[str, str | list[int]]:
        """Get dictionary representation of an interpreter event."""
        return {
            "name": self.name,
            "args": list(self.eth_header) + list(self.ip_header) + list(self.five_tuple),
        }


@dataclass
class IncomingTangoTraffic(TangoEvent):
    """Incoming traffic from a Tango peer."""

    tango_eth_header: EthernetHeader
    tango_ip_header: IPv6Header
    tango_metrics_header: TangoHeader
    encaped_ip_header: IPv4Header
    encaped_five_tuple: FiveTuple

    @property
    def name(self: Self) -> str:
        """Get the name of the event."""
        return "incoming_tango_traffic"

    def as_dict(self: Self) -> dict[str, str | list[int]]:
        """Get dictionary representation of an interpreter event."""
        return {
            "name": self.name,
            "args": list(self.tango_eth_header)
            + list(self.tango_ip_header)
            + list(self.tango_metrics_header)
            + list(self.encaped_ip_header)
            + list(self.encaped_five_tuple),
        }


@dataclass
class RouteUpdate(TangoEvent):
    """Trigger a route update on a peer."""

    sequence_num: int
    update: int

    def __post_init__(self: Self) -> None:
        """Sanitize inputs."""
        if self.sequence_num >= 2**24:
            raise ModelError("Too large of sequence number")
        if self.update >= 2**64:
            raise ModelError("Too large of update")

    @property
    def name(self: Self) -> str:
        """Get the name of the event."""
        return "route_update"

    def as_dict(self: Self) -> dict[str, str | list[int]]:
        """Get dictionary representation of an interpreter event."""
        return {
            "name": self.name,
            "args": [
                self.sequence_num,
                self.update,
            ],
        }


class ArrayName(Enum):
    """Names of all arrays in Tango switch."""

    INCOMING_DECRYPT_PADS_LOWER32 = "incoming_encryption_manager.decryptor.corresponding_otps0"
    INCOMING_DECRYPT_PADS_UPPER32 = "incoming_encryption_manager.decryptor.corresponding_otps1"
    INCOMING_ENCRYPT_PADS_LOWER32 = "incoming_encryption_manager.encryptor.one_time_pads0"
    INCOMING_ENCRYPT_PADS_UPPER32 = "incoming_encryption_manager.encryptor.one_time_pads1"
    ROUTE_MAPPINGS = "route_manager.mappings"
    INCOMING_BOOK_SIG_0 = "incoming_book_signature_manager.onebit_signatures0"
    INCOMING_BOOK_SIG_1 = "incoming_book_signature_manager.onebit_signatures1"
    INCOMING_BOOK_SIG_2 = "incoming_book_signature_manager.onebit_signatures2"
    INCOMING_BOOK_SIG_3 = "incoming_book_signature_manager.onebit_signatures3"
    INCOMING_BOOK_SIG_4 = "incoming_book_signature_manager.onebit_signatures4"
    INCOMING_BOOK_SIG_5 = "incoming_book_signature_manager.onebit_signatures5"
    INCOMING_BOOK_SIG_6 = "incoming_book_signature_manager.onebit_signatures6"
    INCOMING_BOOK_SIG_7 = "incoming_book_signature_manager.onebit_signatures7"
    INCOMING_METRIC_SIG_0 = "incoming_metric_signature_manager.signatures0"
    INCOMING_METRIC_SIG_1 = "incoming_metric_signature_manager.signatures1"
    INCOMING_METRIC_SIG_2 = "incoming_metric_signature_manager.signatures2"
    INCOMING_METRIC_SIG_3 = "incoming_metric_signature_manager.signatures3"
    INCOMING_METRIC_SIG_4 = "incoming_metric_signature_manager.signatures4"
    INCOMING_METRIC_SIG_5 = "incoming_metric_signature_manager.signatures5"
    INCOMING_METRIC_SIG_6 = "incoming_metric_signature_manager.signatures6"
    INCOMING_METRIC_SIG_7 = "incoming_metric_signature_manager.signatures7"
    OUTGOING_BOOK_SIG_0 = "outgoing_book_signature_manager.onebit_signatures0"
    OUTGOING_BOOK_SIG_1 = "outgoing_book_signature_manager.onebit_signatures1"
    OUTGOING_BOOK_SIG_2 = "outgoing_book_signature_manager.onebit_signatures2"
    OUTGOING_BOOK_SIG_3 = "outgoing_book_signature_manager.onebit_signatures3"
    OUTGOING_BOOK_SIG_4 = "outgoing_book_signature_manager.onebit_signatures4"
    OUTGOING_BOOK_SIG_5 = "outgoing_book_signature_manager.onebit_signatures5"
    OUTGOING_BOOK_SIG_6 = "outgoing_book_signature_manager.onebit_signatures6"
    OUTGOING_BOOK_SIG_7 = "outgoing_book_signature_manager.onebit_signatures7"
    OUTGOING_METRIC_SIG_0 = "outgoing_metric_signature_manager.signatures0"
    OUTGOING_METRIC_SIG_1 = "outgoing_metric_signature_manager.signatures1"
    OUTGOING_METRIC_SIG_2 = "outgoing_metric_signature_manager.signatures2"
    OUTGOING_METRIC_SIG_3 = "outgoing_metric_signature_manager.signatures3"
    OUTGOING_METRIC_SIG_4 = "outgoing_metric_signature_manager.signatures4"
    OUTGOING_METRIC_SIG_5 = "outgoing_metric_signature_manager.signatures5"
    OUTGOING_METRIC_SIG_6 = "outgoing_metric_signature_manager.signatures6"
    OUTGOING_METRIC_SIG_7 = "outgoing_metric_signature_manager.signatures7"
    OUTGOING_DECRYPT_PADS_LOWER32 = "outgoing_encryption_manager.decryptor.corresponding_otps0"
    OUTGOING_DECRYPT_PADS_UPPER32 = "outgoing_encryption_manager.decryptor.corresponding_otps1"
    OUTGOING_ENCRYPT_PADS_LOWER32 = "outgoing_encryption_manager.encryptor.one_time_pads0"
    OUTGOING_ENCRYPT_PADS_UPPER32 = "outgoing_encryption_manager.encryptor.one_time_pads1"
    INVALID_PKT_0 = "invalid_pkt_manager.invalid_counts0"
    INVALID_PKT_1 = "invalid_pkt_manager.invalid_counts1"
    INVALID_PKT_2 = "invalid_pkt_manager.invalid_counts2"
    INVALID_PKT_3 = "invalid_pkt_manager.invalid_counts3"
    INVALID_PKT_4 = "invalid_pkt_manager.invalid_counts4"
    INVALID_PKT_5 = "invalid_pkt_manager.invalid_counts5"
    INVALID_PKT_6 = "invalid_pkt_manager.invalid_counts6"
    INVALID_PKT_7 = "invalid_pkt_manager.invalid_counts7"
    BEST_DELAY_VAL = "best_metrics_manager.best_delay_val"
    BEST_LOSS_VAL = "best_metrics_manager.best_loss_val"
    BEST_DELAY_PATH = "best_metrics_manager.best_delay_path"
    BEST_LOSS_PATH = "best_metrics_manager.best_loss_path"
    LOSS_AVGS = "loss_metrics_manager.loss_avgs"
    DELAY_AVGS = "delay_metrics_manager.delay_avgs"


@dataclass
class ArraySet(ControlEvent):
    """Set an index of an array to a value."""

    array: ArrayName
    index: int
    value: int

    @property
    def name(self: Self) -> str:
        """Get the name of the event."""
        return "Array.set"

    def as_dict(self: Self) -> dict[str, str | dict[str, int | list[int]]]:
        """Get dictionary representation of an interpreter event."""
        return {
            "type": "command",
            "name": self.name,
            "args": {
                "array": self.array.value,
                "index": self.index,
                "value": [self.value],
            },
        }


@dataclass
class ArrayGet(ControlEvent):
    """Get an index of an array to a value."""

    array: ArrayName
    index: int

    @property
    def name(self: Self) -> str:
        """Get the name of the event."""
        return "Array.get"

    def as_dict(self: Self) -> dict[str, str | dict[str, int]]:
        """Get dictionary representation of an interpreter event."""
        return {
            "type": "command",
            "name": self.name,
            "args": {
                "array": self.array.value,
                "index": self.index,
            },
        }


@dataclass
class ArraySetRange(ControlEvent):
    """Set a range of indexes of an array to a value."""

    array: ArrayName
    start: int
    end: int
    values: list[int]

    @property
    def name(self: Self) -> str:
        """Get the name of the event."""
        return "Array.setrange"

    def as_dict(self: Self) -> dict[str, str | dict[str, int | list[int]]]:
        """Get dictionary representation of an interpreter event."""
        return {
            "type": "command",
            "name": self.name,
            "args": {
                "array": self.array.value,
                "start": self.start,
                "end": self.end,
                "value": self.values,
            },
        }


@dataclass
class ArrayGetRange(ControlEvent):
    """Get a range of indexes of an array to a value."""

    array: ArrayName
    start: int
    end: int

    @property
    def name(self: Self) -> str:
        """Get the name of the event."""
        return "Array.getrange"

    def as_dict(self: Self) -> dict[str, str | dict[str, int]]:
        """Get dictionary representation of an interpreter event."""
        return {
            "type": "command",
            "name": self.name,
            "args": {
                "array": self.array.value,
                "start": self.start,
                "end": self.end,
            },
        }
