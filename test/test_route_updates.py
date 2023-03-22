"""Test the collection of one-way path metrics."""

from test.models.events import ArrayName, ArraySet, ArraySetRange, IncomingTangoTraffic, RouteUpdate
from test.models.interpreter import ExpectContains, TestCase, TestEvent, TestRunner
from test.models.tango_types import EthernetHeader, FiveTuple, IPv4Header, IPv6Header, TangoHeader

from edu.princeton.tango.mappers.constraints_mapper import (
    ConfiguredConstraintMapper,
    Constraint,
    ConstraintMapping,
)
from edu.princeton.tango.mappers.mapper import OptimizationStrategy
from edu.princeton.tango.mappers.policy_mapper import ConfiguredPolicyMapper, Policy
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


def test_receive_route_update() -> None:
    """Test if a route update is successfully decrypted and applied."""
    given_timeout = 20000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=x), x - 1) for x in range(1, 9)],
    )

    given_header_mapping = ConfiguredHeaderMapper(
        [TunnelHeader(x, IPv6HeaderMap(0, 0, x, 0, 0, 0, 0, 0)) for x in range(0, 8)],
    )

    given_packets = [
        TestEvent(
            RouteUpdate(
                EthernetHeader(0, 0, 0),
                IPv6Header(0, 0, 0, 0, 0, 0, 0, 0),
                0,
                0xFD71B5FF,
                0x7FB6C7B5,
            ),
            timestamp=1000,
        ),
    ]

    given_routes = [
        TestEvent(ArraySet(ArrayName.ROUTE_MAPPINGS, x, x), timestamp=0) for x in range(0, 8)
    ]

    given_pads = [
        TestEvent(ArraySet(ArrayName.INCOMING_DECRYPT_PADS_LOWER32, 0, 0xFD71B5FF), timestamp=0),
        TestEvent(ArraySet(ArrayName.INCOMING_DECRYPT_PADS_UPPER32, 0, 0x5FB6C7B5), timestamp=0),
    ]

    given_events = [*given_routes, *given_pads, *given_packets]

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
                        "route_manager_0(5) : [1u3; 1u32; 2u32; 3u32; 4u32; 5u32;",
                        " 6u32; 7u32; 0u3; 0u3; 0u3; 0u3; 0u3; 0u3; 0u3; 0u3]",
                    ),
                ),
            ),
        ).finish()


def test_loss_route_update_spawn() -> None:
    """Test that corssing a loss threashold causes a route to be triggered."""
    given_timeout = 20000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=x), x - 1) for x in range(1, 9)],
    )

    given_header_mapping = ConfiguredHeaderMapper(
        [TunnelHeader(x, IPv6HeaderMap(0, 0, x, 0, 0, 0, 0, 0)) for x in range(0, 8)],
    )

    given_policy_mapping = ConfiguredPolicyMapper(
        [Policy(x, OptimizationStrategy.OPTIMIZE_LOSS) for x in range(0, 8)],
    )

    given_constraint_mapping = ConfiguredConstraintMapper(
        [
            ConstraintMapping(x, Constraint(2, OptimizationStrategy.OPTIMIZE_LOSS))
            for x in range(0, 8)
        ],
    )

    given_packets = []
    given_num_packets = 65
    for path in [0, 3]:
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
                    [((path + 1) * x) + x for x in range(0, given_num_packets)],
                    range(1000, 1000 + given_num_packets),
                    strict=True,
                )
            ],
        ]

    given_routes = [
        TestEvent(ArraySet(ArrayName.ROUTE_MAPPINGS, x, x), timestamp=0) for x in range(0, 8)
    ]

    given_init_best_path = [
        TestEvent(ArraySet(ArrayName.BEST_LOSS_VAL, 0, 2**32 - 2)),
        TestEvent(ArraySet(ArrayName.BEST_LOSS_PATH, 0, 1)),
        TestEvent(ArraySetRange(ArrayName.LOSS_AVGS, 0, 8, [2**32 - 1])),
    ]

    given_events = [*given_routes, *given_init_best_path, *given_packets]

    given_case = TestCase(given_timeout, given_events)

    with TestRunner(
        given_case,
        class_mapper=given_traffic_mapping,
        header_mapper=given_header_mapping,
        policy_mapper=given_policy_mapping,
        constraint_mapper=given_constraint_mapping,
    ) as when:
        when.run().expect().then(
            ExpectContains(
                "".join(
                    (
                        "route_update",
                        "(65,0,0,0,0,0,0,0,0,0,0,0,805306368,0)",
                        " at port 1, t=1129",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "route_update",
                        "(65,0,0,0,0,1,0,0,0,0,0,0,805306368,0)",
                        " at port 1, t=1129",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "route_update",
                        "(65,0,0,0,0,2,0,0,0,0,0,0,805306368,0)",
                        " at port 1, t=1129",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "route_update",
                        "(65,0,0,0,0,3,0,0,0,0,0,0,805306368,0)",
                        " at port 1, t=1129",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "route_update",
                        "(65,0,0,0,0,4,0,0,0,0,0,0,805306368,0)",
                        " at port 1, t=1129",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "route_update",
                        "(65,0,0,0,0,5,0,0,0,0,0,0,805306368,0)",
                        " at port 1, t=1129",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "route_update",
                        "(65,0,0,0,0,6,0,0,0,0,0,0,805306368,0)",
                        " at port 1, t=1129",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "route_update",
                        "(65,0,0,0,0,7,0,0,0,0,0,0,805306368,0)",
                        " at port 1, t=1129",
                    ),
                ),
            ),
        ).finish()


def test_delay_route_update_spawn() -> None:
    """Test that delay constraint violation results in reroute request."""
    given_timeout = 295_000_000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=x), x - 1) for x in range(1, 9)],
    )

    given_header_mapping = ConfiguredHeaderMapper(
        [TunnelHeader(x, IPv6HeaderMap(0, 0, x, 0, 0, 0, 0, 0)) for x in range(0, 8)],
    )

    given_policy_mapping = ConfiguredPolicyMapper(
        [Policy(x, OptimizationStrategy.OPTIMIZE_DELAY) for x in range(0, 8)],
    )

    given_constraint_mapping = ConfiguredConstraintMapper(
        [
            ConstraintMapping(x, Constraint(100, OptimizationStrategy.OPTIMIZE_DELAY))
            for x in range(0, 8)
        ],
    )

    given_packets = []
    given_num_packets = 33
    for path in [0, 5]:
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
                    [x + 10 for x in range(0, given_num_packets)],
                    [(1_100_000 * x * path) + 1_100_001 for x in range(0, given_num_packets)],
                    strict=True,
                )
            ],
        ]

    given_routes = [
        TestEvent(ArraySet(ArrayName.ROUTE_MAPPINGS, x, x), timestamp=0) for x in range(0, 8)
    ]

    given_init_best_path = [
        TestEvent(ArraySet(ArrayName.BEST_DELAY_VAL, 0, 2**32 - 1)),
        TestEvent(ArraySet(ArrayName.BEST_DELAY_PATH, 0, 5)),
        TestEvent(ArraySetRange(ArrayName.DELAY_AVGS, 0, 8, [2**32 - 1])),
    ]

    given_events = [*given_routes, *given_init_best_path, *given_packets]

    given_case = TestCase(given_timeout, given_events)

    with TestRunner(
        given_case,
        class_mapper=given_traffic_mapping,
        header_mapper=given_header_mapping,
        policy_mapper=given_policy_mapping,
        constraint_mapper=given_constraint_mapping,
    ) as when:
        when.run().expect().then(
            ExpectContains(
                "route_update(31,0,0,0,0,7,0,0,0,0,0,13,1342177280,0) at port 1, t=166100001",
            ),
        ).finish()
