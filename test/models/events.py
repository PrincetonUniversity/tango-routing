"""Models of events for Tango."""
from dataclasses import dataclass
from abc import ABC, abstractmethod

from .error import ModelError

from .types import (
    EthernetHeader,
    IPv4Header,
    FiveTuple,
    IPv6Header,
    TangoHeader,
)


class TangoEvent(ABC):
    """A Tango event which can be tested."""

    @property
    @abstractmethod
    def name(self) -> str:
        """Get the name of the event."""


@dataclass
class ForwardFlow(TangoEvent):
    """Forward Flow event type."""

    eth_header: EthernetHeader
    ip_header: IPv4Header
    five_tuple: FiveTuple

    @property
    def name(self) -> str:
        """Get the name of the event."""

        return "forward_flow"

    def __iter__(self):
        return iter(
            list(self.eth_header)
            + list(self.ip_header)
            + list(self.five_tuple)
        )


@dataclass
class IncomingTangoTraffic(TangoEvent):
    """Incoming traffic from a Tango peer."""

    tango_eth_header: EthernetHeader
    tango_ip_header: IPv6Header
    tango_metrics_header: TangoHeader
    encaped_ip_header: IPv4Header
    encaped_five_tuple: FiveTuple

    @property
    def name(self) -> str:
        """Get the name of the event."""

        return "incoming_tango_traffic"

    def __iter__(self):
        return iter(
            list(self.tango_eth_header)
            + list(self.tango_ip_header)
            + list(self.tango_metrics_header)
            + list(self.encaped_ip_header)
            + list(self.encaped_five_tuple)
        )


@dataclass
class RouteUpdate(TangoEvent):
    """Trigger a route update on a peer."""

    sequence_num: int
    update: int

    def __post_init__(self):
        if self.sequence_num >= 2**4:
            raise ModelError("Too large of path_id")
        if self.update >= 2**64:
            raise ModelError("Too large of timestamp")

    @property
    def name(self) -> str:
        """Get the name of the event."""

        return "route_update"

    def __iter__(self):
        return iter(
            [
                self.sequence_num,
                self.update,
            ]
        )
