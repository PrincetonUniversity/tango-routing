"""Parse Tango configuration."""
from typing import Dict, List, Union, Tuple
from ipaddress import IPv6Address

import yaml
from edu.princeton.tango.mappers.policy_mapper import (
    OptimizationStrategy,
    Policy,
    PolicyMapper,
    DefaultPolicyMapper,
)
from edu.princeton.tango.mappers.traffic_class_mapper import (
    FuzzyClassMapping,
    FuzzyFiveTuple,
    FuzzyIPv4Address,
    TrafficClassMapper,
    DefaultTrafficClassMapper,
)
from edu.princeton.tango.mappers.tunnel_header_mapper import (
    TunnelHeader,
    TunnelHeaderMapper,
    IPv6Header,
    DefaultTunnelHeaderMapper,
)


class ConfigParser:
    """Parse a given tango YAML config."""

    def __init__(self, filename: str) -> None:
        (
            self._header_mapper,
            self._class_mapper,
            self._policy_mapper,
        ) = self._parse_config(filename)

    @property
    def header_mapper(self) -> TunnelHeaderMapper:
        """Map of tunnel headers for path ids."""

        return self._header_mapper

    @property
    def class_mapper(self) -> TrafficClassMapper:
        """Fuzzy matching floes to traffic classes."""

        return self._class_mapper

    @property
    def policy_mapper(self) -> PolicyMapper:
        """Map of optimization policies for given traffic classes."""

        return self._policy_mapper

    def _parse_traffic_class_map(
        self, tc_map: List[Dict[int, Dict[str, Union[str, int]]]]
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

    def _parse_class_policies(
        self, policy_map: Dict[int, str]
    ) -> PolicyMapper:
        """Parse class constraints into Python objects."""

        policies: List[Policy] = []
        for traffic_class, policy in policy_map.items():
            policies.append(
                Policy(traffic_class, OptimizationStrategy[policy])
            )

        return PolicyMapper(policies)

    def _parse_header_map(
        self, header_map: Dict[int, Dict[str, int]]
    ) -> TunnelHeaderMapper:
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

    def _parse_config(
        self,
        config_file: str,
    ) -> Tuple[TunnelHeaderMapper, TrafficClassMapper, PolicyMapper]:
        """Parse a YAML file containing the Tango configuration."""

        with open(config_file, "r", encoding="utf-8") as file:
            config = yaml.load(file, Loader=yaml.Loader)

            tunnel_headers = self._parse_header_map(config["tunnel_headers"])
            traffic_class_mappings = self._parse_traffic_class_map(
                config["traffic_class_mappings"]
            )
            traffic_class_policies = self._parse_class_policies(
                config["traffic_class_policies"]
            )

            return (
                tunnel_headers,
                traffic_class_mappings,
                traffic_class_policies,
            )


class DefaultConfigParser:
    """Restore a default placeholder configuration."""

    @property
    def header_mapper(self) -> DefaultTunnelHeaderMapper:
        """Map of tunnel headers for path ids."""

        return DefaultTunnelHeaderMapper()

    @property
    def class_mapper(self) -> DefaultTrafficClassMapper:
        """Fuzzy matching floes to traffic classes."""

        return DefaultTrafficClassMapper()

    @property
    def policy_mapper(self) -> DefaultPolicyMapper:
        """Map of optimization policies for given traffic classes."""

        return DefaultPolicyMapper()
