"""Map traffic class to its optimzation constraints."""
from dataclasses import dataclass
from typing import Final, LiteralString, Self

from edu.princeton.tango.errors import InvalidParameterError
from edu.princeton.tango.mappers.mapper import Mapper, OptimizationStrategy
from edu.princeton.tango.match_stmt import MatchBody, MatchCase

_DEFAULT_CONSTRAINT_MAP: LiteralString = """include "../Types.dpt"

/**
 * # Description
 * User-generated constraints for every traffic class.
 *
 * # Parameters
 * traffic_class (int<<4>>): traffic class which constrains optimal metrics
 * loss_metrics (LossMetrics_t): loss metrics along this class
 * delay_metrics (DelayMetrics_t): delay metrics along this class
 *
 * # Returns
 * is_within_constraints (bool): metrics satisfy constraints for this class
 **/
fun bool verify_metrics_within_constraints (
    int<<4>> traffic_class,
    int<<32>> loss_metrics,
    int<<32>> delay_metrics
) {
    match (traffic_class) with
    | _ -> {
        printf("ERROR: traffic class map has not been configured!");
        return true;
    }
}

"""

_CONSTRAINT_MAP_TEMPLATE: LiteralString = """include "../Types.dpt"

/**
 * # Description
 * User-generated constraints for every traffic class.
 *
 * # Parameters
 * traffic_class (int<<4>>): traffic class which constrains optimal metrics
 * loss_metrics (LossMetrics_t): loss metrics along this class
 * delay_metrics (DelayMetrics_t): delay metrics along this class
 *
 * # Returns
 * is_within_constraints (bool): metrics satisfy constraints for this class
 **/
fun bool verify_metrics_within_constraints (
    int<<4>> traffic_class,
    int<<32>> loss_metrics,
    int<<32>> delay_metrics
) {{
    match (traffic_class) with
{0}
}}

"""


@dataclass
class Constraint:
    """Constraint on a particular metric."""

    exclusive_constraint: int
    policy: OptimizationStrategy

    def __post_init__(self: Self) -> None:
        """Sanitize inputs."""
        if self.exclusive_constraint >= 2 ** 32:
            raise InvalidParameterError(
                "".join(
                    (
                        "Exclusive constraint is maximum 32-bits:",
                        f"got {self.exclusive_constraint}",
                    ),
                ),
            )

    def __str__(self: Self) -> str:
        """Get lucid comparison implementing constraint."""
        if self.policy == OptimizationStrategy.OPTIMIZE_DELAY:
            return f"{self.exclusive_constraint} > delay_metrics"

        return f"{self.exclusive_constraint} > loss_metrics"


@dataclass
class ConstraintMapping:
    """Map a traffic class to its metric constraints."""

    traffic_class: int
    constraint: Constraint

    def __post_init__(self: Self) -> None:
        """Sanitize inputs."""
        if self.traffic_class >= 15:
            raise InvalidParameterError(
                "".join(
                    (
                        "There is a maximum of 15 traffic classes,",
                        f"zero-indexed: got {self.traffic_class}",
                    ),
                ),
            )


class ConstraintMapper(Mapper):
    """Fuzzy maps all flows to a given traffic class."""

    @property
    def name(self: Self) -> str:
        """Get filename to generate output to."""
        return "TrafficClassConstraintMap.dpt"


class ConfiguredConstraintMapper(ConstraintMapper):
    """Map of traffic classes to their constraints."""

    def __init__(self: Self, constraint_maps: list[ConstraintMapping]) -> None:
        """Create configured traffic class map."""
        resolved_mappings = [
            MatchCase(
                [str(map_.traffic_class)],
                str(map_.constraint),
            )
            for map_ in constraint_maps
        ]

        self._mappings: Final[MatchBody] = MatchBody(resolved_mappings)

    def __str__(self: Self) -> str:
        """Get lucid constraint map file."""
        return _CONSTRAINT_MAP_TEMPLATE.format(str(self._mappings))


class DefaultConstraintMapper(ConstraintMapper):
    """Default placeholder constraint mappings."""

    def __str__(self: Self) -> str:
        """Get lucid constraint map file."""
        return _DEFAULT_CONSTRAINT_MAP
