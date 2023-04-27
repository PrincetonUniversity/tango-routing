"""Send precomputed signature pcap to switch."""

import sys

from scapy.sendrecv import sendp
from scapy.utils import rdpcap


def main() -> None:
    """Send out pcap."""
    if len(sys.argv) != 2:
        print("Usage: <filename>")  # noqa: T201
        sys.exit(-1)

    filename = sys.argv[1]
    pkts = rdpcap(filename)

    sendp(pkts, iface="enp134s0f1")


if __name__ == "__main__":
    main()
