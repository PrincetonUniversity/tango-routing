"""Models of events for Tango."""
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Self

import error
import tango_types


class InterpreterEvent(ABC):
    """Event for the Lucid interpreter."""

    @property
    @abstractmethod
    def name(self: Self) -> str:
        """Get the name of the event."""

    @abstractmethod
    def as_dict(
        self: Self,
    ) -> dict[
        str, int | str | list[int | str] | dict[int | str | list[int | str]]
    ]:
        """Get dictionary representation of an interpreter event."""


class TangoEvent(InterpreterEvent):
    """A Tango event which can be tested."""


class ControlEvent(InterpreterEvent):
    """Command that the control plane can interact with registers."""


@dataclass
class ForwardFlow(TangoEvent):
    """Forward Flow event type."""

    eth_header: tango_types.EthernetHeader
    ip_header: tango_types.IPv4Header
    five_tuple: tango_types.FiveTuple

    @property
    def name(self: Self) -> str:
        """Get the name of the event."""
        return "forward_flow"

    def as_dict(self: Self) -> dict[str, str | list[int]]:
        """Get dictionary representation of an interpreter event."""
        return {
            "name": self.name,
            "args": list(self.eth_header)
            + list(self.ip_header)
            + list(self.five_tuple),
        }


@dataclass
class IncomingTangoTraffic(TangoEvent):
    """Incoming traffic from a Tango peer."""

    tango_eth_header: tango_types.EthernetHeader
    tango_ip_header: tango_types.IPv6Header
    tango_metrics_header: tango_types.TangoHeader
    encaped_ip_header: tango_types.IPv4Header
    encaped_five_tuple: tango_types.FiveTuple

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
            raise error.ModelError("Too large of sequence number")
        if self.update >= 2**64:
            raise error.ModelError("Too large of update")

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


@dataclass
class ArraySet(ControlEvent):
    """Set an index of an array to a value."""

    array: str
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
                "array": self.array,
                "index": self.index,
                "value": [self.value],
            },
        }


@dataclass
class ArrayGet(ControlEvent):
    """Get an index of an array to a value."""

    array: str
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
                "array": self.array,
                "index": self.index,
            },
        }


@dataclass
class ArraySetRange(ControlEvent):
    """Set a range of indexes of an array to a value."""

    array: str
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
                "array": self.array,
                "start": self.start,
                "end": self.end,
                "value": self.values,
            },
        }


@dataclass
class ArrayGetRange(ControlEvent):
    """Get a range of indexes of an array to a value."""

    array: str
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
                "array": self.array,
                "start": self.start,
                "end": self.end,
            },
        }
