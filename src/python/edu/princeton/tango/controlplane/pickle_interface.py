"""General Serialization and Deserialization interface."""

from dataclasses import dataclass


@dataclass
class PrecomputedSignatures:
    """All precomputed signatures."""

    timestamp_signatures: list[int]
    sequence_num_signatures: list[int]
