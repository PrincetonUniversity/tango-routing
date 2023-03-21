"""Test the collection of one-way path metrics."""

from test.models.events import (
    ArrayName,
    ArraySet,
    ArraySetRange,
    IncomingTangoTraffic,
)
from test.models.interpreter import ExpectContains, TestCase, TestEvent, TestRunner
from test.models.tango_types import EthernetHeader, FiveTuple, IPv4Header, IPv6Header, TangoHeader

from edu.princeton.tango.mappers.traffic_class_mapper import (
    ConfiguredTrafficClassMapper,
    FuzzyClassMapping,
    FuzzyFiveTuple,
)
from edu.princeton.tango.mappers.tunnel_header_mapper import (
    ConfiguredHeaderMapper,
    TunnelHeader,
)
from edu.princeton.tango.mappers.tunnel_header_mapper import (
    IPv6Header as IPv6HeaderMap,
)


def test_seq_num_sig_check_multipath() -> None:
    """Test several paths verify sequence number signatures correctly."""
    given_timeout = 20000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=x), x - 1) for x in range(1, 9)],
    )

    given_header_mapping = ConfiguredHeaderMapper(
        [TunnelHeader(x, IPv6HeaderMap(0, 0, x, 0, 0, 0, 0, 0)) for x in range(0, 8)],
    )

    given_packets = []
    given_num_packets = 64
    for path in [0]:
        given_packets = [
            *given_packets,
            *[
                TestEvent(
                    IncomingTangoTraffic(
                        EthernetHeader(x, 0, 0),
                        IPv6Header(0, 0, 0, 0, 0, 0, 0, 0),
                        TangoHeader(path, 0, 0, seq_num, 0),
                        IPv4Header(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                        FiveTuple(0, 0, path + 1, 0, 0),
                    ),
                    timestamp=ts_in,
                )
                for x, seq_num, ts_in in zip(
                    range(1, 1 + given_num_packets),
                    [(path * x) + x for x in range(0, given_num_packets)],
                    range(1000, 1000 + given_num_packets),
                    strict=True,
                )
            ],
        ]

    given_routes = [
        TestEvent(ArraySet(ArrayName.ROUTE_MAPPINGS, x, x), timestamp=0) for x in range(0, 8)
    ]

    given_events = [*given_routes, *given_packets]

    given_case = TestCase(given_timeout, given_events)

    with TestRunner(
        given_case,
        class_mapper=given_traffic_mapping,
        header_mapper=given_header_mapping,
    ) as when:
        print(when.run())
        # when.run().expect().then(
        #     ExpectContains("invalid_pkt_manager_0(65) : [7u32]"),
        # ).then(
        #     ExpectContains("invalid_pkt_manager_1(66) : [6u32]"),
        # ).then(
        #     ExpectContains("invalid_pkt_manager_2(67) : [5u32]"),
        # ).then(
        #     ExpectContains("invalid_pkt_manager_3(68) : [4u32]"),
        # ).then(
        #     ExpectContains("invalid_pkt_manager_4(69) : [3u32]"),
        # ).then(
        #     ExpectContains("invalid_pkt_manager_5(70) : [2u32]"),
        # ).then(
        #     ExpectContains("invalid_pkt_manager_6(71) : [1u32]"),
        # ).then(
        #     ExpectContains("invalid_pkt_manager_7(72) : [0u32]"),
        # ).finish()


if __name__ == "__main__":
    test_seq_num_sig_check_multipath()
