"""Map path-ids to IPv6 Tunnel headers."""
from dataclasses import dataclass
from ipaddress import IPv4Address
from typing import Final, LiteralString, Self

from edu.princeton.tango.cli.errors import InvalidParameterError
from edu.princeton.tango.cli.mappers.mapper import Mapper
from edu.princeton.tango.cli.match_stmt import MatchBody, MatchCase

_DEFAULT_CLASS_MAP: LiteralString = """include "../Types.dpt"

/**
 * # Description
 * User-generated fuzzy mappings between a flow 5-tuple and traffic class.
 *
 * # Parameters
 * src_addr (int<<32>>): source IPv4 adress
 * src_port (int<<16>>): source host port
 * dest_addr (int<<32>>): destination IPv4 adre
 * dest_port (int<<16>>): destination host port
 * protocol (int<<8>>): protocol used
 *
 * # Returns
 * traffic_class (int<<4>>): the traffic class associated with this five-tuple
 **/
fun int<<4>> map_flow_to_traffic_class (
    int<<32>> src_addr,
    int<<16>> src_port,
    int<<32>> dest_addr,
    int<<16>> dest_port,
    int<<8>> protocol
) {
    match (src_addr, src_port, dest_addr, dest_port, protocol) with
    | _, _, _, _, _ -> {
        printf("ERROR: traffic class map has not been configured!");
        return 15;
    }
}

"""

_CLASS_MAP_TEMPLATE: LiteralString = """include "../Types.dpt"

/**
 * # Description
 * User-generated fuzzy mappings between a flow 5-tuple and traffic class.
 *
 * # Parameters
 * src_addr (int<<32>>): source IPv4 adress
 * src_port (int<<16>>): source host port
 * dest_addr (int<<32>>): destination IPv4 adre
 * dest_port (int<<16>>): destination host port
 * protocol (int<<8>>): protocol used
 *
 * # Returns
 * traffic_class (int<<4>>): the traffic class associated with this five-tuple
 **/
fun int<<4>> map_flow_to_traffic_class (
    int<<32>> src_addr,
    int<<16>> src_port,
    int<<32>> dest_addr,
    int<<16>> dest_port,
    int<<8>> protocol
) {{
    match (src_addr, src_port, dest_addr, dest_port, protocol) with
{0}
}}

"""


class FuzzyIPv4Address:
    """Fuzzy-matched IPv4 address with or without prefix."""

    def __init__(self: Self, addr: str) -> None:
        """Create fuzzy-matched IPv4 address."""
        split_addr = addr.split("/")
        if len(split_addr) == 1:
            self._addr = IPv4Address(split_addr[0])
            self._prefix = 0
        elif len(split_addr) == 2:
            self._addr = IPv4Address(split_addr[0])
            self._prefix = int(split_addr[1])
        else:
            raise InvalidParameterError(
                "Improperly formatted IPv4 Address with prefix!",
            )

    def __str__(self: Self) -> str:
        """Get fuzzy-matched IPv4 address."""
        ipv4_bitstring = f"{int(self._addr):032b}"
        if self._prefix > 0:
            ipv4_list = list(ipv4_bitstring)
            ipv4_list.reverse()
            for i in range(0, self._prefix):
                ipv4_list[i] = "*"
            ipv4_list.reverse()
            ipv4_bitstring = "".join(ipv4_list)
        return f"0b{ipv4_bitstring}"


class FuzzyFiveTuple:
    """Fuzzy-matched five-tuple of a particular flow."""

    def __init__(
        self: Self,
        src_addr: FuzzyIPv4Address | None = None,
        src_port: int | None = None,
        dest_addr: FuzzyIPv4Address | None = None,
        dest_port: int | None = None,
        protocol: int | None = None,
    ) -> None:
        """Create a fizzy-matched five-tuple."""
        self._src_addr = src_addr
        self._src_port = src_port
        self._dest_addr = dest_addr
        self._dest_port = dest_port
        self._protocol = protocol

    def __str__(self: Self) -> str:
        """Get five tuple matcher."""
        src_addr_matcher = self._src_addr or "_"
        src_port_matcher = self._src_port or "_"
        dest_addr_matcher = self._dest_addr or "_"
        dest_port_matcher = self._dest_port or "_"
        protocol_matcher = self._protocol or "_"
        return ", ".join(
            (
                f"{src_addr_matcher}",
                f"{src_port_matcher}",
                f"{dest_addr_matcher}",
                f"{dest_port_matcher}",
                f"{protocol_matcher}",
            ),
        )


@dataclass
class FuzzyClassMapping:
    """Fuzzy map a particular flow to a traffic class."""

    five_tuple: FuzzyFiveTuple
    traffic_class: int

    def __post_init__(self: Self) -> None:
        """Sanitize inputs."""
        if self.traffic_class >= 15:
            raise InvalidParameterError(
                "".join(
                    (
                        "There is a maximum of 15 traffic classes,",
                        f"zero-indexed: got {self.traffic_class}",
                    ),
                ),
            )


class TrafficClassMapper(Mapper):
    """Fuzzy maps all flows to a given traffic class."""

    @property
    def name(self: Self) -> str:
        """Get filename to generate output to."""
        return "TrafficClassMap.dpt"


class ConfiguredTrafficClassMapper(TrafficClassMapper):
    """Fuzzy maps all flows to a given traffic class."""

    def __init__(self: Self, fuzzy_maps: list[FuzzyClassMapping]) -> None:
        """Create configured traffic class map."""
        resolved_mappings = [
            MatchCase(
                [str(map_.five_tuple)],
                str(map_.traffic_class),
            )
            for map_ in fuzzy_maps
        ]

        # Append catch-all for non-Tango traffic
        resolved_mappings.append(MatchCase(["_, _, _, _, _"], "15"))

        self._mappings: Final[MatchBody] = MatchBody(resolved_mappings)

    def __str__(self: Self) -> str:
        """Get lucid traffic class map file."""
        return _CLASS_MAP_TEMPLATE.format(str(self._mappings))


class DefaultTrafficClassMapper(TrafficClassMapper):
    """Default placeholder trafffic class mappings."""

    def __str__(self: Self) -> str:
        """Get lucid traffic class map file."""
        return _DEFAULT_CLASS_MAP
