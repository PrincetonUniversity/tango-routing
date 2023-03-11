"""Helper classes from generating match statements."""

from typing import Self

from edu.princeton.tango.errors import InvalidParameterError


class MatchCase:
    """Case in a match statement."""

    def __init__(self: Self, matchers: list[str], ret: str) -> None:
        """Create a Match Case."""
        if len(matchers) == 0:
            raise InvalidParameterError(
                "Match case must match against something!",
            )

        matchers_comb = ", ".join(matchers)
        self._case = f"    | {matchers_comb} -> {{ return {ret}; }}"

    def __str__(self: Self) -> str:
        """Get the lucid-compliant match case."""
        return self._case


class MatchBody:
    """Body of a match statment."""

    def __init__(self: Self, cases: list[MatchCase]) -> None:
        """Create a Match Body."""
        if len(cases) == 0:
            raise InvalidParameterError("Match case must match something!")

        self._body = "\n".join(list(map(str, cases)))

    def __str__(self: Self) -> str:
        """Get a lucid compliant match body."""
        return self._body
