"""Test simple metric collection."""
from models.interpreter import TestCase
from models.interpreter import (
    TestRunner,
    TestEvent,
    ExpectationRunner,
    ExpectContains,
)
from models.events import ForwardFlow, ArraySet, ArrayName
from models.tango_types import EthernetHeader, FiveTuple, IPv4Header
from edu.princeton.tango.mappers.traffic_class_mapper import (
    ConfiguredTrafficClassMapper,
    FuzzyClassMapping,
    FuzzyFiveTuple,
)


def test_timestamp_simple():
    """Test if several sequencial packets are sent with sequence numbers."""
    given_timeout = 10000000

    given_traffic_mapping = ConfiguredTrafficClassMapper(
        [FuzzyClassMapping(FuzzyFiveTuple(src_port=15), 0)]
    )

    given_client_packet = ForwardFlow(
        EthernetHeader(0, 1, 2),
        IPv4Header(3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
        FiveTuple(13, 14, 15, 16, 17),
    )

    given_metric_sigs = [ArraySet(ArrayName.OUTGOING_METRIC_SIG_0, x, x) for x in range(0, 16)]

    given_events = given_metric_sigs + [
        TestEvent(given_client_packet, timestamp=1),
        TestEvent(given_client_packet, timestamp=1500001),
        TestEvent(given_client_packet, timestamp=3000001),
        TestEvent(given_client_packet, timestamp=4500001),
        TestEvent(given_client_packet, timestamp=6000001),
    ]

    given_case = TestCase(given_timeout, given_events)

    with TestRunner(given_case, class_mapper=given_traffic_mapping) as when:
        ExpectationRunner(when.run()).expect(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(0,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)",
                        " at port 1, t=2",
                    )
                )
            )
        ).expect(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(0,1,2,0,0,0,0,0,0,0,0,0,1,1,1,0,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)",
                        " at port 1, t=1500001",
                    )
                )
            )
        ).expect(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(0,1,2,0,0,0,0,0,0,0,0,0,2,2,2,0,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)",
                        " at port 1, t=3000001",
                    )
                )
            )
        ).expect(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(0,1,2,0,0,0,0,0,0,0,0,0,4,4,3,0,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)",
                        " at port 1, t=4500001",
                    )
                )
            )
        ).expect(
            ExpectContains(
                "".join(
                    (
                        "incoming_tango_traffic",
                        "(0,1,2,0,0,0,0,0,0,0,0,0,5,5,4,0,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)",
                        " at port 1, t=6000001",
                    )
                )
            )
        ).finish()


if __name__ == "__main__":
    test_timestamp_simple()
