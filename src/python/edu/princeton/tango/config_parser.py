"""Parse Tango configuration."""
from abc import ABC, abstractmethod
from ipaddress import IPv6Address
from pathlib import Path
from typing import Self

import yaml
from edu.princeton.tango.mappers.constraints_mapper import (
    ConfiguredConstraintMapper,
    Constraint,
    ConstraintMapping,
    DefaultConstraintMapper,
)
from edu.princeton.tango.mappers.policy_mapper import (
    ConfiguredPolicyMapper,
    DefaultPolicyMapper,
    OptimizationStrategy,
    Policy,
)
from edu.princeton.tango.mappers.traffic_class_mapper import (
    ConfiguredTrafficClassMapper,
    DefaultTrafficClassMapper,
    FuzzyClassMapping,
    FuzzyFiveTuple,
    FuzzyIPv4Address,
)
from edu.princeton.tango.mappers.tunnel_header_mapper import (
    ConfiguredHeaderMapper,
    DefaultHeaderMapper,
    IPv6Header,
    TunnelHeader,
)


class ConfigParser(ABC):
    """Abstract class defining a Tango configuration parser."""

    @property
    @abstractmethod
    def header_mapper(self: Self) -> ConfiguredHeaderMapper:
        """Map of tunnel headers for path ids."""

    @property
    @abstractmethod
    def class_mapper(self: Self) -> ConfiguredTrafficClassMapper:
        """Fuzzy matching floes to traffic classes."""

    @property
    @abstractmethod
    def policy_mapper(self: Self) -> ConfiguredPolicyMapper:
        """Map of optimization policies for given traffic classes."""

    @property
    @abstractmethod
    def constraint_mapper(self: Self) -> ConfiguredPolicyMapper:
        """Map of optimization constraints for given traffic classes."""


class YAMLConfigParser(ConfigParser):
    """Parse a given tango YAML config."""

    def __init__(self: Self, filename: str) -> None:
        """Create YAML config parser."""
        (
            self._header_mapper,
            self._class_mapper,
            self._policy_mapper,
            self._constraint_mapper,
        ) = self._parse_config(filename)

    @property
    def header_mapper(self: Self) -> ConfiguredHeaderMapper:
        """Map of tunnel headers for path ids."""
        return self._header_mapper

    @property
    def class_mapper(self: Self) -> ConfiguredTrafficClassMapper:
        """Fuzzy matching floes to traffic classes."""
        return self._class_mapper

    @property
    def policy_mapper(self: Self) -> ConfiguredPolicyMapper:
        """Map of optimization policies for given traffic classes."""
        return self._policy_mapper

    @property
    def constraint_mapper(self: Self) -> ConfiguredPolicyMapper:
        """Map of optimization constraints for given traffic classes."""
        return self._constraint_mapper

    def _parse_traffic_class_map(
        self: Self,
        tc_map: dict[int, list[dict[str, str | int]]],
    ) -> ConfiguredTrafficClassMapper:
        """Parse traffic class map into python objects."""
        mappings: list[FuzzyClassMapping] = []
        for traffic_class, matcher_mappings in tc_map.items():
            for matcher in matcher_mappings:
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
                mappings.append(
                    FuzzyClassMapping(five_tuple, traffic_class),
                )

        return ConfiguredTrafficClassMapper(mappings)

    def _parse_class_policies(
        self: Self,
        policy_map: dict[int, dict[str, str]],
    ) -> ConfiguredPolicyMapper:
        """Parse class constraints into Python objects."""
        policies: list[Policy] = []
        for traffic_class, policy in policy_map.items():
            policies.append(
                Policy(
                    traffic_class,
                    OptimizationStrategy[policy["policy"]],
                ),
            )

        return ConfiguredPolicyMapper(policies)

    def _parse_header_map(
        self: Self,
        header_map: dict[int, dict[str, int]],
    ) -> ConfiguredHeaderMapper:
        """Parse all path id to tunnel header mappings."""
        headers: list[TunnelHeader] = []
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

        return ConfiguredHeaderMapper(headers)

    def _parse_constraint_map(
        self: Self,
        constraint_map: dict[int, dict[str, str]],
    ) -> ConfiguredConstraintMapper:
        """Parse all constraints into mappings."""
        constraint_mappings: list[ConstraintMapping] = []
        for traffic_class, constraint in constraint_map.items():
            constraint_mappings.append(
                ConstraintMapping(
                    traffic_class,
                    Constraint(
                        constraint["constraint"],
                        OptimizationStrategy[constraint["policy"]],
                    ),
                ),
            )

        return ConfiguredConstraintMapper(constraint_mappings)

    def _parse_config(
        self: Self,
        config_file: str,
    ) -> tuple[
        ConfiguredHeaderMapper,
        ConfiguredTrafficClassMapper,
        ConfiguredPolicyMapper,
        ConfiguredConstraintMapper,
    ]:
        """Parse a YAML file containing the Tango configuration."""
        with Path(config_file).open(encoding="utf-8") as file:
            config = yaml.safe_load(file)

            tunnel_headers = self._parse_header_map(config["tunnel_headers"])
            traffic_class_mappings = self._parse_traffic_class_map(
                config["traffic_class_mappings"],
            )
            traffic_class_policies = self._parse_class_policies(
                config["traffic_class_policies"],
            )
            constraint_mappings = self._parse_constraint_map(
                config["traffic_class_policies"],
            )

            return (
                tunnel_headers,
                traffic_class_mappings,
                traffic_class_policies,
                constraint_mappings,
            )


class DefaultConfigParser(ConfigParser):
    """Restore a default placeholder configuration."""

    @property
    def header_mapper(self: Self) -> DefaultHeaderMapper:
        """Map of tunnel headers for path ids."""
        return DefaultHeaderMapper()

    @property
    def class_mapper(self: Self) -> DefaultTrafficClassMapper:
        """Fuzzy matching floes to traffic classes."""
        return DefaultTrafficClassMapper()

    @property
    def policy_mapper(self: Self) -> DefaultPolicyMapper:
        """Map of optimization policies for given traffic classes."""
        return DefaultPolicyMapper()

    @property
    def constraint_mapper(self: Self) -> DefaultConstraintMapper:
        """Map of optimization constraints for given traffic classes."""
        return DefaultConstraintMapper()
