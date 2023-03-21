"""Test the collection of one-way path metrics."""

from test.models.events import (
    ArrayName,
    ArraySet,
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


def test_seq_num_metrics_multipath() -> None:
    """Test several paths verify sequence number signatures correctly."""
    given_timeout = 20000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=x), x - 1) for x in range(1, 9)],
    )

    given_header_mapping = ConfiguredHeaderMapper(
        [TunnelHeader(x, IPv6HeaderMap(0, 0, x, 0, 0, 0, 0, 0)) for x in range(0, 8)],
    )

    given_packets = []
    given_num_packets = 65
    for path in range(0, 8):
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
        when.run().expect().then(
            ExpectContains(
                "".join(
                    (
                        "loss_metrics_manager_10(56) :",
                        " [0u32; 126u32; 189u32; 252u32; 315u32; 378u32; 441u32; 504u32]",
                    ),
                ),
            ),
        ).finish()


def test_delay_metrics_multipath() -> None:
    """Test several paths verify sequence number signatures correctly."""
    given_timeout = 295_000_000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=x), x - 1) for x in range(1, 9)],
    )

    given_header_mapping = ConfiguredHeaderMapper(
        [TunnelHeader(x, IPv6HeaderMap(0, 0, x, 0, 0, 0, 0, 0)) for x in range(0, 8)],
    )

    given_packets = []
    given_num_packets = 33
    for path in range(0, 8):
        given_packets = [
            *given_packets,
            *[
                TestEvent(
                    IncomingTangoTraffic(
                        EthernetHeader(x, 0, 0),
                        IPv6Header(0, 0, 0, 0, 0, 0, 0, 0),
                        TangoHeader(path, ts_out, 0, 0, 0),
                        IPv4Header(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                        FiveTuple(0, 0, path + 1, 0, 0),
                    ),
                    timestamp=ts_in,
                )
                for x, ts_out, ts_in in zip(
                    range(1, 1 + given_num_packets),
                    [(1_100_000 * x) + 1 for x in range(0, given_num_packets)],
                    [(1_100_000 * x * path) + 1_100_001 for x in range(0, given_num_packets)],
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
        when.run().expect().then(
            ExpectContains(
                "".join(
                    (
                        "delay_metrics_manager_9(66) : [59136u32; 61436u32;",
                        " 61955u32; 62475u32; 62995u32; 63515u32; 64035u32; 64556u32]",
                    ),
                ),
            ),
        ).finish()


if __name__ == "__main__":
    test_delay_sig_check_multipath()
