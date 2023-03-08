"""Mapping generator base class."""
from abc import ABC, abstractmethod
from typing import Self


class Mapper(ABC):
    """Mapping generator."""

    @property
    @abstractmethod
    def name(self: Self) -> str:
        """Get filename to generate output to."""
