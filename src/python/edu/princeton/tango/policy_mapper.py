"""Map traffic classes to pre-defined optimization strategies."""
from dataclasses import dataclass
from enum import Enum, auto
from typing import Final, List, LiteralString

from edu.princeton.tango.errors import InvalidParameterError
from edu.princeton.tango.match_stmt import MatchBody, MatchCase

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


class OptimizationStrategy(Enum):
    """A policy indicating which optimziation strategy to use."""

    OPTIMIZE_DELAY = auto()
    OPTIMIZE_LOSS = auto()

    def __str__(self):
        return f"{self.name}"


@dataclass
class Policy:
    """Map a particular traffic class to a policy type."""

    traffic_class: int
    policy: OptimizationStrategy

    def __post_init__(self):
        if self.traffic_class >= 15:
            raise InvalidParameterError(
                "".join(
                    (
                        "There is a maximum of 15 traffic classes,",
                        f" zero-indexed: got {self.traffic_class}",
                    )
                )
            )


class DefaultPolicyMapper:
    """Default placeholder policy mappings."""

    def __str__(self) -> str:
        return _DEFAULT_OPTIMIZATION_MAP


class PolicyMapper(DefaultPolicyMapper):
    """Maps all traffic classes to policies"""

    def __init__(self, policies: List[Policy]) -> None:
        if len(policies) >= 15:
            raise InvalidParameterError(
                "".join(
                    (
                        "There is a maximum of 15 traffic classes:",
                        f" got {len(policies)}",
                    )
                )
            )

        policies.sort(key=lambda policy: policy.traffic_class)

        resolved_policies = list(
            map(
                lambda policy: MatchCase(
                    [str(policy.traffic_class)], str(policy.policy)
                ),
                policies,
            )
        )
        self._policies: Final[MatchBody] = MatchBody(resolved_policies)

    def __str__(self) -> str:
        return _OPTIMIZATION_MAP_TEMPLATE.format(str(self._policies))
