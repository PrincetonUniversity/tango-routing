"""Map path-ids to IPv6 Tunnel headers."""
from dataclasses import dataclass
from ipaddress import IPv6Address
from typing import Final, LiteralString, Self

from edu.princeton.tango.errors import InvalidParameterError
from edu.princeton.tango.mappers.mapper import Mapper
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

size NUM_VALID_PATHS = 1;

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

size NUM_VALID_PATHS = {0};

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
{1}
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

    def __post_init__(self: Self) -> None:
        """Sanitize inputs."""
        if self.version >= 2 ** 4:
            raise InvalidParameterError(
                f"`version` ({self.version}) is more than 4-bit!",
            )

        if self.traffic_class >= 2 ** 8:
            raise InvalidParameterError(
                f"`traffic_class` ({self.traffic_class}) is more than 8-bit!",
            )

        if self.flow_label >= 2 ** 20:
            raise InvalidParameterError(
                f"`flow_label` ({self.flow_label}) is more than 20-bit!",
            )

        if self.payload_len >= 2 ** 16:
            raise InvalidParameterError(
                f"`payload_len` ({self.payload_len}) is more than 16-bit!",
            )

        if self.next_header >= 2 ** 8:
            raise InvalidParameterError(
                f"`next_header` ({self.next_header}) is more than 8-bit!",
            )

        if self.hop_limit >= 2 ** 8:
            raise InvalidParameterError(
                f"`hop_limit` ({self.hop_limit}) is more than 8-bit!",
            )

    def __str__(self: Self) -> str:
        """Get lucid representation for header."""
        version_bin = f"{self.version:0{4}b}"
        traffic_class_bin = f"{self.traffic_class:0{8}b}"
        flow_label_bin = f"{self.flow_label:0{20}b}"
        version_cls_flow_bin = "".join((flow_label_bin, traffic_class_bin, version_bin))

        version_cls_flow = int(version_cls_flow_bin, 2)
        return " ".join(
            (
                "{",
                f"version_cls_flow = {version_cls_flow};" f"payload_len = {self.payload_len};",
                f"next_header = {self.next_header};",
                f"hop_limit = {self.hop_limit};",
                f"src_addr = {int(self.src_addr)};",
                f"dest_addr = {int(self.dest_addr)};",
                "}",
            ),
        )


@dataclass
class TunnelHeader:
    """Map a particular path id to IPv6 tunnel header."""

    path_id: int
    header: IPv6Header

    def __post_init__(self: Self) -> None:
        """Sanitize inputs."""
        if self.path_id >= 8:
            raise InvalidParameterError(
                "".join(
                    (
                        "There is a maximum of 8 paths,",
                        f"zero-indexed: got {self.path_id}",
                    ),
                ),
            )


class HeaderMapper(Mapper):
    """Maps all path ids to given tunnel headers."""

    @property
    def name(self: Self) -> str:
        """Get filename to generate output to."""
        return "TunnelHeaderMap.dpt"


class ConfiguredHeaderMapper(HeaderMapper):
    """Maps all path ids to given tunnel headers."""

    def __init__(self: Self, headers: list[TunnelHeader]) -> None:
        """Create a configured header map."""
        if len(headers) > 8:
            raise InvalidParameterError(
                f"There is a maximum of 8 traffic classes: got {len(headers)}",
            )

        self._num_paths = len(headers)

        headers.sort(key=lambda hdr: hdr.path_id)

        resolved_headers = [MatchCase([str(hdr.path_id)], str(hdr.header)) for hdr in headers]
        self._headers: Final[MatchBody] = MatchBody(resolved_headers)

    def __str__(self: Self) -> str:
        """Get lucid file of header map."""
        return _HEADER_MAP_TEMPLATE.format(self._num_paths, str(self._headers))


class DefaultHeaderMapper(HeaderMapper):
    """Default placeholder tunnel headers."""

    def __str__(self: Self) -> str:
        """Get lucid file of header map."""
        return _DEFAULT_HEADER_MAP
