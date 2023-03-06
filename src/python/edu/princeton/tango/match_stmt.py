"""Helper classes from generating match statements."""

from typing import List

from edu.princeton.tango.errors import InvalidParameterError


class MatchCase:
    """Case in a match statement."""

    def __init__(self, matchers: List[str], ret: str) -> None:
        if len(matchers) == 0:
            raise InvalidParameterError(
                "Match case must match against something!"
            )

        matchers_comb = ", ".join(matchers)
        self._case = f"    | {matchers_comb} -> {{ return {ret}; }}"

    def __str__(self) -> str:
        return self._case


class MatchBody:
    """Body of a match statment"""

    def __init__(self, cases: List[MatchCase]) -> None:
        if len(cases) == 0:
            raise InvalidParameterError("Match case must match something!")

        self._body = "\n".join(list(map(str, cases)))

    def __str__(self) -> str:
        return self._body
