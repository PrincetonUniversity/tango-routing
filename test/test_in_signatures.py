"""Test simple metric signature checks."""

from ipaddress import IPv6Address
from test.models.events import ArrayName, ArraySet, ArraySetRange, IncomingTangoTraffic
from test.models.interpreter import ExpectContains, TestCase, TestEvent, TestRunner
from test.models.tango_types import EthernetHeader, IPv4Header, IPv6Header, TangoHeader, TCPHeader

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


def test_timestamp_sig_check_one_path() -> None:
    """Test if several sequencial packets are sent with valid signatures."""
    given_timeout = 25000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=15), 0)],
    )

    given_packets = [
        TestEvent(
            IncomingTangoTraffic(
                EthernetHeader(x, 0, 0),
                IPv6Header(0, 0, 0, 0, 0, 0, 0, 0),
                TangoHeader(0, ts_out, sig, 0, 0),
                IPv4Header(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                TCPHeader(15, x, 0, 0, 0, 0, 0, 0),
            ),
            timestamp=ts_in,
        )
        for x, sig, ts_out, ts_in in zip(
            range(1, 6),
            [0, 2, 3, 4, 5],
            [1, 1500001, 3000001, 4500001, 6000001],
            [5000001, 6500001, 8000001, 12500001, 14000001],
            strict=True,
        )
    ]

    given_events = [*given_packets]

    given_case = TestCase(given_timeout, given_events)

    with TestRunner(given_case, class_mapper=given_traffic_mapping) as when:
        when.run().expect().then(
            ExpectContains(
                "".join(
                    (
                        "invalid_pkt_manager_0(40) : ",
                        "[4u32; 0u32; 0u32; 0u32; 0u32; 0u32; 0u32; 0u32]",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "complete_forward",
                        "(1,0,0,0,0,0,0,0,0,0,0,0,0,15,1,0,0,0,0,0,0)",
                        " at port -1, t=5000001",  # FIXME: Strange that it's at port -1
                    ),
                ),
            ),
        ).finish()


def test_seq_num_sig_check_one_path() -> None:
    """Test if several sequencial packets are sent with valid signatures."""
    given_timeout = 25000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=15), 0)],
    )

    given_packets = [
        TestEvent(
            IncomingTangoTraffic(
                EthernetHeader(x, 0, 0),
                IPv6Header(0, 0, 0, 0, 0, 0, 0, 0),
                TangoHeader(0, ts_out, 0, x - 1, sig),
                IPv4Header(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                TCPHeader(15, x, 0, 0, 0, 0, 0, 0),
            ),
            timestamp=ts_in,
        )
        for x, sig, ts_out, ts_in in zip(
            range(1, 6),
            [0, 1, 1, 1, 1],
            [1, 1500001, 3000001, 4500001, 6000001],
            [5000001, 6500001, 8000001, 12500001, 14000001],
            strict=True,
        )
    ]

    given_events = [*given_packets]

    given_case = TestCase(given_timeout, given_events)

    with TestRunner(given_case, class_mapper=given_traffic_mapping) as when:
        when.run().expect().then(
            ExpectContains(
                "".join(
                    (
                        "invalid_pkt_manager_0(40) : ",
                        "[4u32; 0u32; 0u32; 0u32; 0u32; 0u32; 0u32; 0u32]",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "complete_forward",
                        "(1,0,0,0,0,0,0,0,0,0,0,0,0,15,1,0,0,0,0,0,0)",
                        " at port -1, t=5000001",  # FIXME: Strange that it's at port -1
                    ),
                ),
            ),
        ).finish()


def test_timestamp_sig_check_multipath() -> None:
    """Test several paths verify timestamp signatures correctly."""
    given_timeout = 20000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=x), x - 1) for x in range(1, 9)],
    )

    given_header_mapping = ConfiguredHeaderMapper(
        [
            TunnelHeader(x, IPv6HeaderMap(0, 0, x, 0, 0, 0, IPv6Address(0), IPv6Address(0)))
            for x in range(0, 8)
        ],
    )

    given_packets = []
    for path in range(0, 8):
        given_packets = [
            *given_packets,
            *[
                TestEvent(
                    IncomingTangoTraffic(
                        EthernetHeader(x, 0, 0),
                        IPv6Header(0, 0, 0, 0, 0, 0, 0, 0),
                        TangoHeader(path, ts_out, sig, 0, 0),
                        IPv4Header(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                        TCPHeader(x, path + 1, 0, 0, 0, 0, 0, 0),
                    ),
                    timestamp=ts_in,
                )
                for x, sig, ts_out, ts_in in zip(
                    range(1, 9),
                    [x if x < path + 2 else 0 for x in range(1, 9)],
                    range(0, 8),
                    [x * 1500000 + 5000001 for x in range(0, 8)],
                    strict=True,
                )
            ],
        ]

    given_routes = [
        TestEvent(ArraySet(ArrayName.ROUTE_MAPPINGS, x, x), timestamp=0) for x in range(0, 8)
    ]

    given_metric_sigs = []
    for path in range(0, 8):
        given_metric_sigs = [
            *given_metric_sigs,
            *[
                TestEvent(ArraySet(ArrayName[f"INCOMING_METRIC_SIG_{path}"], x, x + 1), timestamp=0)
                for x in range(0, 8)
            ],
        ]

    given_events = [*given_routes, *given_metric_sigs, *given_packets]

    given_case = TestCase(given_timeout, given_events)

    with TestRunner(
        given_case,
        class_mapper=given_traffic_mapping,
        header_mapper=given_header_mapping,
    ) as when:
        when.run().expect().then(
            ExpectContains("".join((
                        "invalid_pkt_manager_0(40) : ",
                        "[7u32; 6u32; 5u32; 4u32; 3u32; 2u32; 1u32; 0u32]",
                    ),
                ),
            ),
        ).finish()


def test_seq_num_sig_check_multipath() -> None:
    """Test several paths verify sequence number signatures correctly."""
    given_timeout = 20000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=x), x - 1) for x in range(1, 9)],
    )

    given_header_mapping = ConfiguredHeaderMapper(
        [
            TunnelHeader(x, IPv6HeaderMap(0, 0, x, 0, 0, 0, IPv6Address(0), IPv6Address(0)))
            for x in range(0, 8)
        ],
    )

    given_packets = []
    for path in range(0, 8):
        given_packets = [
            *given_packets,
            *[
                TestEvent(
                    IncomingTangoTraffic(
                        EthernetHeader(x, 0, 0),
                        IPv6Header(0, 0, 0, 0, 0, 0, 0, 0),
                        TangoHeader(path, 0, 0, seq_num, sig),
                        IPv4Header(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                        TCPHeader(x, path + 1, 0, 0, 0, 0, 0, 0),
                    ),
                    timestamp=ts_in,
                )
                for x, sig, seq_num, ts_in in zip(
                    range(1, 9),
                    [1 if x < path + 2 else 0 for x in range(1, 9)],
                    range(0, 8),
                    range(1000, 1008),
                    strict=True,
                )
            ],
        ]

    given_routes = [
        TestEvent(ArraySet(ArrayName.ROUTE_MAPPINGS, x, x), timestamp=0) for x in range(0, 8)
    ]

    given_book_sigs = [
        TestEvent(ArraySetRange(ArrayName[f"INCOMING_BOOK_SIG_{path}"], 0, 16, [1]), timestamp=0)
        for path in range(0, 8)
    ]

    given_events = [*given_routes, *given_book_sigs, *given_packets]

    given_case = TestCase(given_timeout, given_events)

    with TestRunner(
        given_case,
        class_mapper=given_traffic_mapping,
        header_mapper=given_header_mapping,
    ) as when:
        when.run().expect().then(
            ExpectContains("".join((
                        "invalid_pkt_manager_0(40) : ",
                        "[7u32; 6u32; 5u32; 4u32; 3u32; 2u32; 1u32; 0u32]",
                    ),
                ),
            ),
        ).finish()
