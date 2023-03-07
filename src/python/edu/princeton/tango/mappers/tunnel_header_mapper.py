"""Map path-ids to IPv6 Tunnel headers."""
from abc import ABC
from dataclasses import dataclass
from ipaddress import IPv6Address
from typing import Final, List, LiteralString

from edu.princeton.tango.errors import InvalidParameterError
from edu.princeton.tango.match_stmt import MatchBody, MatchCase

_DEFAULT_HEADER_MAP: LiteralString = """include "../Types.dpt"

const IPv6Header_t DUMMY_HDR = {
    version = 0;
    traffic_class = 0;
    flow_label = 0;
    payload_len = 0;
    next_header = 0;
    hop_limit = 0;
    src_addr = 0;
    dest_addr = 0;
};

/**
 * # Description
 * Get a Tango header for a given packet to tunnel over a particular
 * physical path.
 *
 * # Parameters
 * self (t): self
 * path_id (int<<3>>): path upon the invalid packet was found
 *
 * # Returns
 * tunnel_header (IPv6Header_t): tunnel header corresponding to phyisical path
 **/
fun IPv6Header_t map_path_to_tunnel_header (int<<3>> path_id) {
    match (path_id) with
    | _ -> {
        printf("ERROR: tunnel header map has not been configured!");
        return DUMMY_HDR;
    }
}

"""

_HEADER_MAP_TEMPLATE: LiteralString = """include "../Types.dpt"

/**
 * # Description
 * Get a Tango header for a given packet to tunnel over a particular
 * physical path.
 *
 * # Parameters
 * self (t): self
 * path_id (int<<3>>): path upon the invalid packet was found
 *
 * # Returns
 * tunnel_header (IPv6Header_t): tunnel header corresponding to phyisical path
 **/
fun IPv6Header_t map_path_to_tunnel_header (int<<3>> path_id) {{
    match (path_id) with
{0}
}}

"""


@dataclass
class IPv6Header:
    """A IPv6 tunnel header."""

    version: int
    traffic_class: int
    flow_label: int
    payload_len: int
    next_header: int
    hop_limit: int
    src_addr: IPv6Address
    dest_addr: IPv6Address

    def __post_init__(self):
        if self.version >= 2**4:
            raise InvalidParameterError(
                f"`version` ({self.version}) is more than 4-bit!"
            )

        if self.traffic_class >= 2**8:
            raise InvalidParameterError(
                f"`traffic_class` ({self.traffic_class}) is more than 8-bit!"
            )

        if self.flow_label >= 2**20:
            raise InvalidParameterError(
                f"`flow_label` ({self.flow_label}) is more than 20-bit!"
            )

        if self.payload_len >= 2**16:
            raise InvalidParameterError(
                f"`payload_len` ({self.payload_len}) is more than 16-bit!"
            )

        if self.next_header >= 2**8:
            raise InvalidParameterError(
                f"`next_header` ({self.next_header}) is more than 8-bit!"
            )

        if self.hop_limit >= 2**8:
            raise InvalidParameterError(
                f"`hop_limit` ({self.hop_limit}) is more than 8-bit!"
            )

    def __str__(self) -> str:
        return " ".join(
            (
                "{",
                f"version = {self.version};",
                f"traffic_class = {self.traffic_class};",
                f"flow_label = {self.flow_label};",
                f"payload_len = {self.payload_len};",
                f"next_header = {self.next_header};",
                f"hop_limit = {self.hop_limit};",
                f"src_addr = {int(self.src_addr)};",
                f"dest_addr = {int(self.dest_addr)};",
                "}",
            )
        )


@dataclass
class TunnelHeader:
    """Map a particular path id to IPv6 tunnel header."""

    path_id: int
    header: IPv6Header

    def __post_init__(self):
        if self.path_id >= 8:
            raise InvalidParameterError(
                "".join(
                    (
                        "There is a maximum of 8 paths,",
                        f"zero-indexed: got {self.path_id}",
                    )
                )
            )


class HeaderMapper(ABC):
    """Maps all path ids to given tunnel headers."""


class ConfiguredHeaderMapper(HeaderMapper):
    """Maps all path ids to given tunnel headers."""

    def __init__(self, headers: List[TunnelHeader]) -> None:
        if len(headers) >= 8:
            raise InvalidParameterError(
                f"There is a maximum of 8 traffic classes: got {len(headers)}"
            )

        headers.sort(key=lambda hdr: hdr.path_id)

        resolved_headers = list(
            map(
                lambda hdr: MatchCase([str(hdr.path_id)], str(hdr.header)),
                headers,
            )
        )
        self._headers: Final[MatchBody] = MatchBody(resolved_headers)

    def __str__(self) -> str:
        return _HEADER_MAP_TEMPLATE.format(str(self._headers))


class DefaultHeaderMapper(HeaderMapper):
    """Default placeholder tunnel headers."""

    def __str__(self) -> str:
        return _DEFAULT_HEADER_MAP
