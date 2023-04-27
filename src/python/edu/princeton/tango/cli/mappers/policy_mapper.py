"""Map traffic classes to pre-defined optimization strategies."""
from dataclasses import dataclass
from typing import Final, LiteralString, Self

from edu.princeton.tango.cli.errors import InvalidParameterError
from edu.princeton.tango.cli.mappers.mapper import Mapper, OptimizationStrategy
from edu.princeton.tango.cli.match_stmt import MatchBody, MatchCase

_DEFAULT_OPTIMIZATION_MAP: LiteralString = """include "../Types.dpt"

const bool OPTIMIZE_DELAY = false;
const bool OPTIMIZE_LOSS = true;

/**
 * # Description
 * Opmization policies for every traffic class.
 *
 * # Parameters
 * traffic_class (int<<4>>): traffic class whose policy is of interest
 *
 * # Returns
 * policy (bool): optimization policy for the given traffic class
 **/
fun bool map_traffic_class_to_policy (int<<4>> traffic_class) {
    match (traffic_class) with
    | _ -> {
        printf("ERROR: optimization policy map has not been configured!");
        return OPTIMIZE_DELAY;
    }
}

"""

_OPTIMIZATION_MAP_TEMPLATE: LiteralString = """include "../Types.dpt"

const bool OPTIMIZE_DELAY = false;
const bool OPTIMIZE_LOSS = true;

/**
 * # Description
 * Opmization policies for every traffic class.
 *
 * # Parameters
 * traffic_class (int<<4>>): traffic class whose policy is of interest
 *
 * # Returns
 * policy (bool): optimization policy for the given traffic class
 **/
fun bool map_traffic_class_to_policy (int<<4>> traffic_class) {{
    match (traffic_class) with
{0}
}}

"""


@dataclass
class Policy:
    """Map a particular traffic class to a policy type."""

    traffic_class: int
    policy: OptimizationStrategy

    def __post_init__(self: Self) -> None:
        """Sanitize inputs."""
        if self.traffic_class >= 15:
            raise InvalidParameterError(
                "".join(
                    (
                        "There is a maximum of 15 traffic classes,",
                        f" zero-indexed: got {self.traffic_class}",
                    ),
                ),
            )


class PolicyMapper(Mapper):
    """Maps all traffic classes to policies."""

    @property
    def name(self: Self) -> str:
        """Get filename to generate output to."""
        return "TrafficClassOpmizationMap.dpt"


class ConfiguredPolicyMapper(PolicyMapper):
    """Maps all traffic classes to policies."""

    def __init__(self: Self, policies: list[Policy]) -> None:
        """Create configured policy map."""
        if len(policies) >= 15:
            raise InvalidParameterError(
                "".join(
                    (
                        "There is a maximum of 15 traffic classes:",
                        f" got {len(policies)}",
                    ),
                ),
            )

        policies.sort(key=lambda policy: policy.traffic_class)

        resolved_policies = [
            MatchCase(
                [str(policy.traffic_class)],
                str(policy.policy),
            )
            for policy in policies
        ]
        self._policies: Final[MatchBody] = MatchBody(resolved_policies)

    def __str__(self: Self) -> str:
        """Get lucid policy map file."""
        return _OPTIMIZATION_MAP_TEMPLATE.format(str(self._policies))


class DefaultPolicyMapper(PolicyMapper):
    """Default placeholder policy mappings."""

    def __str__(self: Self) -> str:
        """Get lucid policy map file."""
        return _DEFAULT_OPTIMIZATION_MAP
