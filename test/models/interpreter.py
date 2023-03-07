"""Interpreter configuration models."""
import json
from tempfile import TemporaryDirectory
from typing import Dict, List, Optional
from dataclasses import dataclass
from pathlib import Path
import events
import error


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

    sender: EventLocation
    recevier: EventLocation

    def as_dict(self) -> Dict[str, str]:
        """Convert to a dictionary."""

        send = f"{self.sender.router_id}:{self.sender.port}"
        rcv = f"{self.recevier.router_id}:{self.recevier.port}"
        return {send: rcv}


class TestEvent:
    """Interpreter event to be injected into test system."""

    def __init__(
        self,
        event: events.TangoEvent,
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
        event_list: List[TestEvent],
        switches: Optional[int] = None,
        link_list: Optional[List[EventLink]] = None,
        default_input_gap: Optional[int] = None,
        generate_delay: Optional[int] = None,
        random_delay_range: Optional[int] = None,
        random_seed: Optional[int] = None,
    ) -> None:
        self._max_time = max_time
        self._events = event_list
        self._switches = switches
        self._links = link_list
        self._default_input_gap = default_input_gap
        self._generate_delay = generate_delay
        self._random_delay_range = random_delay_range
        self._random_seed = random_seed

    def as_dict(self) -> Dict[str, str]:
        """Convert to a dictionary."""

        config = {}
        config["max time"] = self._max_time
        config["events"] = list(map(list, self._events))

        if self._switches:
            config["switches"] = self._switches

        if self._links:
            all_links = {}
            for link in self._links:
                all_links.update(link.as_dict())
            config["links"] = all_links

        if self._default_input_gap:
            config["default input gap"] = self._default_input_gap

        if self._generate_delay:
            config["generate delay"] = self._generate_delay

        if self._random_delay_range:
            config["random delay range"] = self._random_delay_range

        if self._random_seed:
            config["random seed"] = self._random_seed

        return config

    @property
    def json(self) -> str:
        """Get test case in json string form."""

        return json.dumps(self.as_dict())


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
        self._tmp_dir = None

    def __enter__(self) -> "TestRunner":
        self._tmp_dir = TemporaryDirectory(prefix="tango")
        return self

    def __exit__(self, _, __, ____) -> None:
        self._tmp_dir.cleanup()

    def _create_test_file(self) -> None:
        """Make the json test file."""

        if not self._tmp_dir:
            raise error.UsageError("Must be called within context manager!")

        config_file = Path(self._tmp_dir.name) / Path("test.yaml")
        config_file.write_text(self._given.json)
        print(config_file.read_text())

    def run(self) -> TestResult:
        """Execute the interpreter."""

        self._create_test_file()
