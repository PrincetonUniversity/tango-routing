"""Test simple traffic class to path routing."""


from ipaddress import IPv6Address
from test.models.events import ArrayGet, ArrayName, ArraySet, ForwardFlow
from test.models.interpreter import (
    ExpectContains,
    TestCase,
    TestEvent,
    TestRunner,
)
from test.models.tango_types import EthernetHeader, IPv4Header, TCPHeader

from edu.princeton.tango.mappers.traffic_class_mapper import (
    ConfiguredTrafficClassMapper,
    FuzzyClassMapping,
    FuzzyFiveTuple,
)
from edu.princeton.tango.mappers.tunnel_header_mapper import (
    ConfiguredHeaderMapper,
    IPv6Header,
    TunnelHeader,
)


def test_simple_route() -> None:
    """Test if several sequencial packets are sent over correct paths."""
    given_timeout = 10000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=x), x - 1) for x in range(1, 9)],
    )

    given_header_mapping = ConfiguredHeaderMapper(
        [
            TunnelHeader(x, IPv6Header(0, 0, 0, 0, 0, 0, IPv6Address(x), IPv6Address(x)))
            for x in range(0, 8)
        ],
    )

    given_packets = [
        TestEvent(
            ForwardFlow(
                EthernetHeader(x, 0, 0),
                IPv4Header(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                TCPHeader(x, 0, 0, 0, 0, 0, 0, 0),
            ),
            timestamp=ts,
        )
        for x, ts in zip(range(1, 9), range(1, 9), strict=True)
    ]

    given_routes = [ArraySet(ArrayName.ROUTE_MAPPINGS, x, x) for x in range(0, 8)]

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
                        "incoming_tango_traffic",
                        "(1,0,0,0,88,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0)",
                        " at port 1, t=2",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(2,0,0,0,88,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0)",
                        " at port 1, t=3",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(3,0,0,0,88,0,0,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0)",
                        " at port 1, t=6",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(4,0,0,0,88,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0)",
                        " at port 1, t=7",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(5,0,0,0,88,0,0,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0)",
                        " at port 1, t=10",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(6,0,0,0,88,0,0,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0)",
                        " at port 1, t=11",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(7,0,0,0,88,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0)",
                        " at port 1, t=14",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(8,0,0,0,88,0,0,7,7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0)",
                        " at port 1, t=15",
                    ),
                ),
            ),
        ).finish()


def test_multipath_timestamps() -> None:
    """Test if several sequencial packets are sent with timestamp signatures."""
    given_timeout = 10000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=x), x - 1) for x in range(1, 9)],
    )

    given_header_mapping = ConfiguredHeaderMapper(
        [
            TunnelHeader(x, IPv6Header(0, 0, x, 0, 0, 0, IPv6Address(0), IPv6Address(0)))
            for x in range(0, 8)
        ],
    )

    given_packets = [
        TestEvent(
            ForwardFlow(
                EthernetHeader(x, 0, 0),
                IPv4Header(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                TCPHeader(x, 0, 0, 0, 0, 0, 0, 0),
            ),
            timestamp=ts,
        )
        for x, ts in zip(range(1, 9), range(1001, 1009), strict=True)
    ]

    given_routes = [ArraySet(ArrayName.ROUTE_MAPPINGS, x, x) for x in range(0, 8)]
    given_timestamps = [
        ArraySet(ArrayName[f"OUTGOING_METRIC_SIG_{x}"], 0, x + 1) for x in range(0, 8)
    ]

    given_events = [*given_routes, *given_timestamps, *given_packets]

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
                        "incoming_tango_traffic",
                        "(1,0,0,0,88,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0)",
                        " at port 1, t=1001",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(2,0,0,4096,88,0,0,0,0,1,0,2,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0)",
                        " at port 1, t=1002",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(3,0,0,8192,88,0,0,0,0,2,0,3,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0)",
                        " at port 1, t=1003",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(4,0,0,12288,88,0,0,0,0,3,0,4,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0)",
                        " at port 1, t=1004",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(5,0,0,16384,88,0,0,0,0,4,0,5,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0)",
                        " at port 1, t=1005",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(6,0,0,20480,88,0,0,0,0,5,0,6,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0)",
                        " at port 1, t=1006",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(7,0,0,24576,88,0,0,0,0,6,0,7,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0)",
                        " at port 1, t=1007",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(8,0,0,28672,88,0,0,0,0,7,0,8,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0)",
                        " at port 1, t=1008",
                    ),
                ),
            ),
        ).finish()


def test_multipath_sequence_nums() -> None:
    """Test if several sequencial packets are sent with sequence number signatures."""
    given_timeout = 10000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=x), x - 1) for x in range(1, 9)],
    )

    given_header_mapping = ConfiguredHeaderMapper(
        [
            TunnelHeader(x, IPv6Header(0, 0, x, 0, 0, 0, IPv6Address(0), IPv6Address(0)))
            for x in range(0, 8)
        ],
    )

    given_packets = [
        TestEvent(
            ForwardFlow(
                EthernetHeader(x, 0, 0),
                IPv4Header(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                TCPHeader(x, 0, 0, 0, 0, 0, 0, 0),
            ),
            timestamp=ts,
        )
        for x, ts in zip(range(1, 9), range(1001, 1009), strict=True)
    ]

    given_routes = [ArraySet(ArrayName.ROUTE_MAPPINGS, x, x) for x in range(0, 8)]
    given_book_sigs = [ArraySet(ArrayName[f"OUTGOING_BOOK_SIG_{x}"], 0, x % 2) for x in range(0, 8)]
    get_book_sigs = [ArrayGet(ArrayName[f"OUTGOING_BOOK_SIG_{x}"], 0) for x in range(0, 8)]

    given_events = [*given_routes, *given_book_sigs, *get_book_sigs, *given_packets]

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
                        "incoming_tango_traffic",
                        "(1,0,0,0,88,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0)",
                        " at port 1, t=1001",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(2,0,0,4096,88,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0)",
                        " at port 1, t=1002",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(3,0,0,8192,88,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0)",
                        " at port 1, t=1003",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(4,0,0,12288,88,0,0,0,0,3,0,0,0,1,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0)",
                        " at port 1, t=1004",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(5,0,0,16384,88,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0)",
                        " at port 1, t=1005",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(6,0,0,20480,88,0,0,0,0,5,0,0,0,1,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0)",
                        " at port 1, t=1006",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(7,0,0,24576,88,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0)",
                        " at port 1, t=1007",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(8,0,0,28672,88,0,0,0,0,7,0,0,0,1,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0)",
                        " at port 1, t=1008",
                    ),
                ),
            ),
        ).finish()
