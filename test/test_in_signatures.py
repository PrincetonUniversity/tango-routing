# """Test simple metric signature checks."""

# from test.models.events import ArrayName, ArraySet, IncomingTangoTraffic
# from test.models.interpreter import (
#     TestCase,
#     TestEvent,
#     TestRunner,
# )
# from test.models.tango_types import EthernetHeader, FiveTuple, IPv4Header, IPv6Header, TangoHeader

# from edu.princeton.tango.mappers.traffic_class_mapper import (
#     ConfiguredTrafficClassMapper,
#     FuzzyClassMapping,
#     FuzzyFiveTuple,
# )


# def test_timestamp_sig_check_one_path() -> None:
#     """Test if several sequencial packets are sent with valid signatures."""
#     given_timeout = 10000000

#     given_traffic_mapping = ConfiguredTrafficClassMapper(
#         [FuzzyClassMapping(FuzzyFiveTuple(src_port=15), 0)],
#     )

#     given_packets = [
#         TestEvent(
#             IncomingTangoTraffic(
#                 EthernetHeader(x, 0, 0),
#                 IPv6Header(0, 0, 0, 0, 0, 0, 0, 0),
#                 TangoHeader(0, ts_out, sig, 0, 0),
#                 IPv4Header(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#                 FiveTuple(0, 0, 15, 0, 0),
#             ),
#             timestamp=ts_in,
#         )
#         for x, sig, ts_out, ts_in in zip(
#             range(1, 6),
#             [0, 1, 0, 0, 4],
#             [1, 1500001, 3000001, 4500001, 6000001],
#             [5000001, 6500001, 8000001, 12500001, 14000001],
#             strict=True,
#         )
#     ]

#     given_metric_sigs = [ArraySet(ArrayName.INCOMING_METRIC_SIG_0, x, x) for x in range(0, 16)]

#     given_events = [*given_metric_sigs, *given_packets]

#     given_case = TestCase(given_timeout, given_events)

#     with TestRunner(given_case, class_mapper=given_traffic_mapping) as when:
#         print(when.run())  # noqa: T201


# if __name__ == "__main__":
#     test_timestamp_sig_check_one_path()
