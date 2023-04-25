"""Send a few signature writes to switch."""

from enum import Enum

from scapy.layers.inet6 import (
    UDP,
    ByteField,
    Ether,
    IntField,
    IPv6,
    Packet,
    ShortField,
)
from scapy.sendrecv import sendp


class SignatureType(Enum):
    """Type of signature being written."""

    SEQNUM_SIG = 0
    TS_SIG = 1


class SignatureMetadata(Packet):
    """Metadata about where to write signature stream."""

    name = "SignatureMetadata"
    fields_desc = [
        ByteField("sig_type", 0),
        ShortField("sig_idx", 0),
        ByteField("block_idx", 0),
    ]


class Signature(Packet):
    """Single signature payload of packet."""

    name = "Signature"
    fields_desc = [IntField("signature", 0)]


def main() -> None:
    """Send reroute packets to switch."""
    pkts = []

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(sig_type=SignatureType.SEQNUM_SIG.value, sig_idx=0, block_idx=0)
        / Signature(signature=1)
        / Signature(signature=0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(sig_type=SignatureType.SEQNUM_SIG.value, sig_idx=1, block_idx=0)
        / Signature(signature=2)
        / Signature(signature=3)
        / Signature(signature=4)
        / Signature(signature=0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(sig_type=SignatureType.SEQNUM_SIG.value, sig_idx=0, block_idx=1)
        / Signature(signature=5)
        / Signature(signature=0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(sig_type=SignatureType.SEQNUM_SIG.value, sig_idx=1, block_idx=1)
        / Signature(signature=6)
        / Signature(signature=7)
        / Signature(signature=8)
        / Signature(signature=0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(sig_type=SignatureType.TS_SIG.value, sig_idx=0, block_idx=0)
        / Signature(signature=1)
        / Signature(signature=0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(sig_type=SignatureType.TS_SIG.value, sig_idx=1, block_idx=0)
        / Signature(signature=2)
        / Signature(signature=3)
        / Signature(signature=4)
        / Signature(signature=0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(sig_type=SignatureType.TS_SIG.value, sig_idx=0, block_idx=1)
        / Signature(signature=5)
        / Signature(signature=0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(sig_type=SignatureType.TS_SIG.value, sig_idx=1, block_idx=1)
        / Signature(signature=6)
        / Signature(signature=7)
        / Signature(signature=8)
        / Signature(signature=0),
    )

    sendp(pkts, iface="enp134s0f1")


if __name__ == "__main__":
    main()
