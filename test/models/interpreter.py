"""Interpreter configuration models."""
from typing import Dict, List, Optional
from dataclasses import dataclass
from .events import TangoEvent


@dataclass
class EventLocation:
    """Tie router id and port together as a location."""

    router_id: int
    port: int

    def __str__(self) -> str:
        return f"{self.router_id}:{self.port}"


@dataclass
class EventLink:
    """Tie router id and port together as a location."""

    router_send_id: int
    send_port: int
    router_rcv_id: int
    rcv_port: int

    def as_dict(self) -> Dict[str, str]:
        """Convert to a dictionary."""

        send = f"{self.router_send_id}:{self.send_port}"
        rcv = f"{self.router_rcv_id}:{self.rcv_port}"
        return {send: rcv}


class TestEvent:
    """Interpreter event to be injected into test system."""

    def __init__(
        self,
        event: TangoEvent,
        timestamp: Optional[int] = None,
        locations: Optional[List[EventLocation]] = None,
    ) -> None:
        self._event = event
        self._timestamp = timestamp
        self._locations = locations

    def as_dict(self) -> Dict[str, str]:
        """Convert to a dictionary."""

        event = {}
        event["name"] = self._event.name
        event["args"] = list(self._event)

        if self._timestamp:
            event["timestamp"] = self._timestamp

        if self._locations:
            event["locations"] = list(map(str, self._locations))

        return event


@dataclass
class TestCase:
    """A configuration for a Lucid interpreter test."""

    def __init__(
        self,
        max_time: int,
        events: List[TestEvent],
        switches: Optional[int] = None,
        links: Optional[List[EventLink]] = None,
        default_input_gap: Optional[int] = None,
        generate_delay: Optional[int] = None,
        random_delay_range: Optional[int] = None,
        random_seed: Optional[int] = None,
    ) -> None:
        self._max_time = max_time
        self._events = events
        self._switches = switches
        self._links = links
        self._default_input_gap = default_input_gap
        self._generate_delay = generate_delay
        self._random_delay_range = random_delay_range
        self._random_seed = random_seed

    def as_dict(self) -> Dict[str, str]:
        """Convert to a dictionary."""

        config = {}
        config["max time"] = self._max_time
        config["events"] = list(map(lambda e: e.as_dict(), self._events))

        if self._switches:
            config["switches"] = self._switches

        if self._links:
            links = {}
            for link in self._links:
                links.update(link.as_dict())
            config["links"] = links

        if self._default_input_gap:
            config["default input gap"] = self._default_input_gap

        if self._generate_delay:
            config["generate delay"] = self._generate_delay

        if self._random_delay_range:
            config["random delay range"] = self._random_delay_range

        if self._random_seed:
            config["random seed"] = self._random_seed

        return config


class ExpectedResult:
    """Expected result of an interpreter test."""

    # TODO: IMPLEMENT


class TestResult:
    """Result of an interpreter run."""

    # TODO: IMPLEMENT


class TestRunner:
    """Run a Lucid interpreter test."""

    def __init__(self, given: TestCase) -> None:
        self._given = given

    def run(self) -> TestResult:
        """Execute the interpreter."""

        # TODO: IMPLEMENT
