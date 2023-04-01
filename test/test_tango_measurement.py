"""Test simple metric signature access."""

from test.models.events import ArrayName, ArraySet, ForwardFlow
from test.models.interpreter import ExpectContains, TestBinary, TestCase, TestEvent, TestRunner
from test.models.tango_types import EthernetHeader, IPv4Header, UDPHeader

from edu.princeton.tango.mappers.traffic_class_mapper import (
    ConfiguredTrafficClassMapper,
    FuzzyClassMapping,
    FuzzyFiveTuple,
)


def test_metrics_header() -> None:
    """Test if several sequencial packets are sent with sequence numbers."""
    given_timeout = 10000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=x), x - 1) for x in range(1, 9)],
    )

    given_packets = []
    for path in range(1, 9):
        given_packets = [
            *given_packets,
            *[
                TestEvent(
                    ForwardFlow(
                        EthernetHeader(x, 0, 0),
                        IPv4Header(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                        UDPHeader(path, 0, 0, 0),
                    ),
                    timestamp=ts,
                )
                for x, ts in zip(range(1, 6), [9, 1500001, 3000001, 4500001, 6000001], strict=True)
            ],
        ]

    given_routes = [ArraySet(ArrayName.ROUTE_MAPPINGS, x, x) for x in range(0, 8)]
    given_events = [*given_routes, *given_packets]

    given_case = TestCase(given_timeout, given_events)

    with TestRunner(
        given_case,
        class_mapper=given_traffic_mapping,
        test_binary=TestBinary.TANGO_MEASUREMENT,
    ) as when:
        when.run().expect().then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(5,0,0,0,88,0,0,0,0,1,5,0,4,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0)",
                        " at port -1, t=6000001",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(5,0,0,0,88,0,0,0,0,3,5,0,4,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0)",
                        " at port -1, t=6000002",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(5,0,0,0,88,0,0,0,0,2,5,0,4,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0)",
                        " at port -1, t=6000003",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(5,0,0,0,88,0,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0)",
                        " at port -1, t=6000004",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(5,0,0,0,88,0,0,0,0,4,5,0,4,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0)",
                        " at port -1, t=6000005",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(5,0,0,0,88,0,0,0,0,5,5,0,4,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0)",
                        " at port -1, t=6000006",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(5,0,0,0,88,0,0,0,0,7,5,0,4,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0)",
                        " at port -1, t=6000007",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(5,0,0,0,88,0,0,0,0,6,5,0,4,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0)",
                        " at port -1, t=6000008",
                    ),
                ),
            ),
        ).finish()
