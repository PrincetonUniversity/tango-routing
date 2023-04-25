"""Send a few signature writes to switch."""

from enum import Enum

from scapy.layers.inet6 import (
    UDP,
    ByteEnumField,
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
        ByteEnumField(
            "sig_type",
            0,
            {0: SignatureType.SEQNUM_SIG.value, 1: SignatureType.TS_SIG.value},
        ),
        ShortField("sig_idx", 0),
        ByteField("block_idx", 0),
    ]


class Signature(Packet):
    """Single signature payload of packet."""

    name = "Signature"
    fields_desc = [IntField("Signature", 0)]


def main() -> None:
    """Send reroute packets to switch."""
    pkts = []

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(SignatureType.SEQNUM_SIG.value, 0, 0)
        / Signature(1)
        / Signature(0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(SignatureType.SEQNUM_SIG.value, 1, 0)
        / Signature(2)
        / Signature(3)
        / Signature(4)
        / Signature(0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(SignatureType.SEQNUM_SIG.value, 0, 1)
        / Signature(5)
        / Signature(0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(SignatureType.SEQNUM_SIG.value, 1, 1)
        / Signature(6)
        / Signature(7)
        / Signature(8)
        / Signature(0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(SignatureType.TS_SIG.value, 0, 0)
        / Signature(1)
        / Signature(0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(SignatureType.TS_SIG.value, 1, 0)
        / Signature(2)
        / Signature(3)
        / Signature(4)
        / Signature(0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(SignatureType.TS_SIG.value, 0, 1)
        / Signature(5)
        / Signature(0),
    )

    pkts.append(
        Ether()
        / IPv6()
        / UDP()
        / SignatureMetadata(SignatureType.TS_SIG.value, 1, 1)
        / Signature(6)
        / Signature(7)
        / Signature(8)
        / Signature(0),
    )

    sendp(pkts, iface="enp134s0f1")


if __name__ == "__main__":
    main()
