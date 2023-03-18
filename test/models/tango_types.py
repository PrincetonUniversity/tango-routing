"""Models of Tango record types."""
from collections.abc import Iterable
from dataclasses import dataclass
from typing import Self

from models.error import ModelError


@dataclass
class EthernetHeader:
    """Ethernet header of a packet."""

    dest_mac: int
    src_mac: int
    ethertype: int

    def __post_init__(self: Self) -> None:
        """Do sanitization."""
        if self.dest_mac >= 2**48:
            raise ModelError("Too large of dest mac")
        if self.src_mac >= 2**48:
            raise ModelError("Too large of src mac")
        if self.ethertype >= 2**16:
            raise ModelError("Too large of ethertype")

    def __iter__(self: Self) -> Iterable[int]:
        """Get iterable of values."""
        return iter(
            [
                self.dest_mac,
                self.src_mac,
                self.ethertype,
            ],
        )


@dataclass
class IPv4Header:
    """IPv4 header of a packet."""

    version_ihl: int
    type_of_svc: int
    len_: int
    id_: int
    flags_fragment_offset: int
    ttl: int
    protocol: int
    checksum: int
    src_addr: int
    dest_addr: int

    def __post_init__(self: Self) -> None:
        """Do sanitization."""
        if self.version_ihl >= 2**8:
            raise ModelError("Too large of version")
        if self.type_of_svc >= 2**8:
            raise ModelError("Too large of service type")
        if self.len_ >= 2**16:
            raise ModelError("Too large of length")
        if self.id_ >= 2**16:
            raise ModelError("Too large of id")
        if self.flags_fragment_offset >= 2**16:
            raise ModelError("Too large of fragment offset")
        if self.ttl >= 2**8:
            raise ModelError("Too large of ttl")
        if self.protocol >= 2**8:
            raise ModelError("Too large of protocol")
        if self.checksum >= 2**16:
            raise ModelError("Too large of checksum")
        if self.src_addr >= 2**32:
            raise ModelError("Too large of source address")
        if self.dest_addr >= 2**32:
            raise ModelError("Too large of destination address")

    def __iter__(self: Self) -> Iterable[int]:
        """Get iterable of values."""
        return iter(
            [
                self.version_ihl,
                self.type_of_svc,
                self.len_,
                self.id_,
                self.flags_fragment_offset,
                self.ttl,
                self.protocol,
                self.checksum,
                self.src_addr,
                self.dest_addr,
            ],
        )


@dataclass
class FiveTuple:
    """Five Tuple of a packet."""

    src_addr: int
    dest_addr: int
    src_port: int
    dest_port: int
    protocol: int

    def __post_init__(self: Self) -> None:
        """Do sanitization."""
        if self.src_addr >= 2**32:
            raise ModelError("Too large of source address")
        if self.dest_addr >= 2**32:
            raise ModelError("Too large of destination address")
        if self.src_port >= 2**16:
            raise ModelError("Too large of source port")
        if self.dest_port >= 2**16:
            raise ModelError("Too large of destination port")
        if self.protocol >= 2**8:
            raise ModelError("Too large of protocol")

    def __iter__(self: Self) -> Iterable[int]:
        """Get iterable of values."""
        return iter(
            [
                self.src_addr,
                self.dest_addr,
                self.src_port,
                self.dest_port,
                self.protocol,
            ],
        )


@dataclass
class IPv6Header:
    """A IPv6 tunnel header."""

    version: int
    traffic_class: int
    flow_label: int
    payload_len: int
    next_header: int
    hop_limit: int
    src_addr: int
    dest_addr: int

    def __post_init__(self: Self) -> None:
        """Do sanitization."""
        if self.version >= 2**4:
            raise ModelError("Too large of version")
        if self.traffic_class >= 2**8:
            raise ModelError("Too large of traffic_class")
        if self.flow_label >= 2**20:
            raise ModelError("Too large of flow_label")
        if self.payload_len >= 2**16:
            raise ModelError("Too large of payload_len")
        if self.next_header >= 2**8:
            raise ModelError("Too large of next_header")
        if self.hop_limit >= 2**8:
            raise ModelError("Too large of hop_limit")
        if self.src_addr >= 2**128:
            raise ModelError("Too large of src_addr")
        if self.dest_addr >= 2**128:
            raise ModelError("Too large of dest_addr")

    def __iter__(self: Self) -> Iterable[int]:
        """Get iterable of values."""
        return iter(
            [
                self.version,
                self.traffic_class,
                self.flow_label,
                self.payload_len,
                self.next_header,
                self.hop_limit,
                self.src_addr,
                self.dest_addr,
            ],
        )


@dataclass
class TangoHeader:
    """Tango Metric header."""

    path_id: int
    timestamp: int
    signature: int
    sequence_num: int
    book_signature: int

    def __post_init__(self: Self) -> None:
        """Do sanitization."""
        if self.path_id >= 2**3:
            raise ModelError("Too large of path_id")
        if self.timestamp >= 2**12:
            raise ModelError("Too large of timestamp")
        if self.signature >= 2**32:
            raise ModelError("Too large of signature")
        if self.sequence_num >= 2**24:
            raise ModelError("Too large of sequence_num")
        if self.book_signature >= 2**1:
            raise ModelError("Too large of book_signature")

    def __iter__(self: Self) -> Iterable[int]:
        """Get iterable of values."""
        return iter(
            [
                self.path_id,
                self.timestamp,
                self.signature,
                self.sequence_num,
                self.book_signature,
            ],
        )
