"""Parse Tango configuration."""
import sys
from typing import Dict, List, Union
from ipaddress import IPv6Address

import yaml
from edu.princeton.tango.policy_mapper import (
    OptimizationStrategy,
    Policy,
    PolicyMapper,
)
from edu.princeton.tango.traffic_class_mapper import (
    FuzzyClassMapping,
    FuzzyFiveTuple,
    FuzzyIPv4Address,
    TrafficClassMapper,
)
from edu.princeton.tango.tunnel_header_mapper import (
    TunnelHeader,
    TunnelHeaderMapper,
    IPv6Header,
)


def parse_traffic_class_map(
    tc_map: List[Dict[int, Dict[str, Union[str, int]]]]
) -> TrafficClassMapper:
    """Parse traffic class map into python objects."""

    mappings: List[FuzzyClassMapping] = []
    for mapping in tc_map:
        for traffic_class, matcher in mapping.items():
            src_addr = (
                FuzzyIPv4Address(matcher.get("src_addr"))
                if matcher.get("src_addr")
                else None
            )
            dest_addr = (
                FuzzyIPv4Address(matcher.get("dest_addr"))
                if matcher.get("dest_addr")
                else None
            )
            five_tuple = FuzzyFiveTuple(
                src_addr,
                matcher.get("src_port"),
                dest_addr,
                matcher.get("dest_port"),
                matcher.get("protocol"),
            )
            mappings.append(FuzzyClassMapping(five_tuple, traffic_class))

    return TrafficClassMapper(mappings)


def parse_class_policies(policy_map: Dict[int, str]) -> PolicyMapper:
    """Parse class constraints into Python objects."""

    policies: List[Policy] = []
    for traffic_class, policy in policy_map.items():
        policies.append(Policy(traffic_class, OptimizationStrategy[policy]))

    return PolicyMapper(policies)


def parse_header_map(header_map: Dict[int, Dict[str, int]]) -> None:
    """Parse all path id to tunnel header mappings."""

    headers: List[TunnelHeader] = []
    for path_id, header_fields in header_map.items():
        header = IPv6Header(
            version=int(header_fields["version"]),
            traffic_class=int(header_fields["traffic_class"]),
            flow_label=int(header_fields["flow_label"]),
            payload_len=int(header_fields["payload_len"]),
            next_header=int(header_fields["next_header"]),
            hop_limit=int(header_fields["hop_limit"]),
            src_addr=IPv6Address(header_fields["src_addr"]),
            dest_addr=IPv6Address(header_fields["dest_addr"]),
        )
        headers.append(TunnelHeader(path_id, header))

    return TunnelHeaderMapper(headers)


def main(config_file: str) -> None:
    """Parse a YAML file containing the Tango configuration."""

    with open(config_file, "r", encoding="utf-8") as file:
        config = yaml.load(file, Loader=yaml.Loader)

        tunnel_headers = parse_header_map(config["tunnel_headers"])
        traffic_class_mappings = parse_traffic_class_map(
            config["traffic_class_mappings"]
        )
        traffic_class_policies = parse_class_policies(
            config["traffic_class_policies"]
        )

    with open("headers.dpt", "w+", encoding="utf-8") as file:
        file.write(str(tunnel_headers))
    with open("mappings.dpt", "w+", encoding="utf-8") as file:
        file.write(str(traffic_class_mappings))
    with open("policies.dpt", "w+", encoding="utf-8") as file:
        file.write(str(traffic_class_policies))


if __name__ == "__main__":
    main(sys.argv[1])
