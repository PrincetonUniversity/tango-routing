"""Test simple metric signature access."""

from test.models.events import ArrayName, ArraySet, ForwardFlow
from test.models.interpreter import ExpectContains, TestCase, TestEvent, TestRunner
from test.models.tango_types import EthernetHeader, IPv4Header, TCPHeader

from edu.princeton.tango.mappers.traffic_class_mapper import (
    ConfiguredTrafficClassMapper,
    FuzzyClassMapping,
    FuzzyFiveTuple,
)


def test_timestamp_simple() -> None:
    """Test if several sequencial packets are sent with sequence numbers."""
    given_timeout = 10000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=15), 0)],
    )

    given_client_packet = ForwardFlow(
        EthernetHeader(0, 1, 2),
        IPv4Header(3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
        TCPHeader(13, 14, 15, 16, 17, 18, 19, 20),
    )

    given_metric_sigs = [ArraySet(ArrayName.OUTGOING_METRIC_SIG_0, x, x) for x in range(0, 16)]

    given_events = [
        *given_metric_sigs,
        TestEvent(given_client_packet, timestamp=1),
        TestEvent(given_client_packet, timestamp=1500001),
        TestEvent(given_client_packet, timestamp=3000001),
        TestEvent(given_client_packet, timestamp=4500001),
        TestEvent(given_client_packet, timestamp=6000001),
    ]

    given_case = TestCase(given_timeout, given_events)

    with TestRunner(given_case, class_mapper=given_traffic_mapping) as when:
        when.run().expect().then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(0,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)",
                        " at port 1, t=2",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(0,1,2,0,0,0,0,0,0,0,0,0,1,1,1,0,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)",
                        " at port 1, t=1500001",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(0,1,2,0,0,0,0,0,0,0,0,0,2,2,2,0,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)",
                        " at port 1, t=3000001",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(0,1,2,0,0,0,0,0,0,0,0,0,4,4,3,0,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)",
                        " at port 1, t=4500001",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(0,1,2,0,0,0,0,0,0,0,0,0,5,5,4,0,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)",
                        " at port 1, t=6000001",
                    ),
                ),
            ),
        ).finish()


def test_sequence_num_simple() -> None:
    """Test that sequence numbers are updated as expected."""
    given_timeout = 10000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=15), 0)],
    )

    given_packets = [
        TestEvent(
            ForwardFlow(
                EthernetHeader(x, 0, 0),
                IPv4Header(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                TCPHeader(13, 14, 15, 16, 17, 18, 19, 20),
            ),
            timestamp=ts,
        )
        for x, ts in zip(range(1, 6), [1, 1500001, 3000001, 4500001, 6000001], strict=True)
    ]

    given_book_sigs = [ArraySet(ArrayName.OUTGOING_BOOK_SIG_0, x, x % 2) for x in range(0, 16)]

    given_events = [*given_book_sigs, *given_packets]

    given_case = TestCase(given_timeout, given_events)

    with TestRunner(given_case, class_mapper=given_traffic_mapping) as when:
        when.run().expect().then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0)",
                        " at port 1, t=2",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(2,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0)",
                        " at port 1, t=1500001",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(3,0,0,0,0,0,0,0,0,0,0,0,2,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0)",
                        " at port 1, t=3000001",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(4,0,0,0,0,0,0,0,0,0,0,0,4,0,3,1,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0)",
                        " at port 1, t=4500001",
                    ),
                ),
            ),
        ).then(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(5,0,0,0,0,0,0,0,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0)",
                        " at port 1, t=6000001",
                    ),
                ),
            ),
        ).finish()
