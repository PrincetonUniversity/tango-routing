"""Send reroutes to switch."""

from scapy.layers.inet6 import UDP, ByteField, Ether, IPv6, Packet
from scapy.sendrecv import sendp


class RouteUpdate(Packet):
    """Update route layer to trigger reroute on Tango node."""

    name = "TangoUpdateRoute"
    fields_desc = [ByteField("traffic_class", 0), ByteField("new_path_id", 0)]


def main() -> None:
    """Send reroute packets to switch."""
    pkts = [
        Ether()
        / IPv6()
        / UDP()
        / RouteUpdate(traffic_class=i, new_path_id=(7 - (i % 8)))
        for i in range(0, 32)
    ]

    sendp(pkts, iface="enp134s0f1")


if __name__ == "__main__":
    main()
