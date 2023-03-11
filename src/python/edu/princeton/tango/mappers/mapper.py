"""Mapping generator base class."""
from abc import ABC, abstractmethod
from enum import Enum, auto
from typing import Self


class Mapper(ABC):
    """Mapping generator."""

    @property
    @abstractmethod
    def name(self: Self) -> str:
        """Get filename to generate output to."""


class OptimizationStrategy(Enum):
    """A policy indicating which optimziation strategy to use."""

    OPTIMIZE_DELAY = auto()
    OPTIMIZE_LOSS = auto()

    def __str__(self: Self) -> str:
        """Get the optimization strategy."""
        return f"{self.name}"
