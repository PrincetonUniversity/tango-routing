"""Interpreter configuration models."""
import json
from abc import ABC, abstractmethod
from dataclasses import dataclass
from pathlib import Path
from shutil import copytree, rmtree
from subprocess import run as run_cmd
from tempfile import mkdtemp
from test.models.error import DptError, UsageError
from test.models.events import InterpreterEvent, TangoEvent
from typing import Self

from edu.princeton.tango.mappers import HeaderMapper, PolicyMapper, TrafficClassMapper
from edu.princeton.tango.mappers.mapper import Mapper


@dataclass
class EventLocation:
    """Tie router id and port together as a location."""

    router_id: int
    port: int

    def __str__(self: Self) -> str:
        """Convert to expected formatted string."""
        return f"{self.router_id}:{self.port}"

    def __int__(self: Self) -> int:
        """Get integer definition of event location (router id)."""
        return self.router_id


@dataclass
class EventLink:
    """Tie router id and port together as a location."""

    sender: EventLocation
    recevier: EventLocation

    def as_dict(self: Self) -> dict[str, str]:
        """Convert to a dictionary."""
        send = f"{self.sender.router_id}:{self.sender.port}"
        rcv = f"{self.recevier.router_id}:{self.recevier.port}"
        return {send: rcv}


class TestEvent:
    """Interpreter event to be injected into test system."""

    __test__ = False

    def __init__(
        self: Self,
        event: InterpreterEvent,
        timestamp: int | None = None,
        locations: list[EventLocation] | None = None,
    ) -> None:
        """Create a test event."""
        self._event = event
        self._timestamp = timestamp
        self._locations = locations

    def as_dict(self: Self) -> dict[str, str]:
        """Convert to a dictionary."""
        event = self._event.as_dict()

        if self._timestamp:
            event["timestamp"] = self._timestamp

        if self._locations:
            if isinstance(self._event, TangoEvent):
                event["locations"] = list(map(str, self._locations))
            else:
                event["locations"] = list(map(int, self._locations))

        return event


@dataclass
class TestCase:
    """A configuration for a Lucid interpreter test."""

    __test__ = False

    def __init__(
        self: Self,
        max_time: int,
        event_list: list[TestEvent],
        switches: int | None = None,
        link_list: list[EventLink] | None = None,
        default_input_gap: int | None = None,
        generate_delay: int | None = None,
        random_delay_range: int | None = None,
        random_seed: int | None = None,
    ) -> None:
        """Create a test case."""
        self._max_time = max_time
        self._events = event_list
        self._switches = switches
        self._links = link_list
        self._default_input_gap = default_input_gap
        self._generate_delay = generate_delay
        self._random_delay_range = random_delay_range
        self._random_seed = random_seed

    def as_dict(self: Self) -> dict[str, str]:
        """Convert to a dictionary."""
        config = {}
        config["max time"] = self._max_time
        config["events"] = [e.as_dict() for e in self._events]

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
    def json(self: Self) -> str:
        """Get test case in json string form."""
        return json.dumps(self.as_dict())


class TestResult:
    """Result of an interpreter run."""

    __test__ = False

    def __init__(self: Self, result: str) -> None:
        """Create a Test Result."""
        self._res = result

    def __str__(self: Self) -> str:
        """Give back the raw string form of the interpreter output."""
        return self._res

    def expect(self: Self) -> "ExpectationRunner":
        """Get prepopulated expectation runner."""
        return ExpectationRunner(self)


class ExpectedResult(ABC):
    """Expected result of an interpreter test."""

    __test__ = False

    @abstractmethod
    def check(self: Self, result: TestResult) -> None:
        """Check result for a property."""


class ExpectContains(ExpectedResult):
    """Assert that result has a particular substring within."""

    def __init__(self: Self, expect: str) -> None:
        """Create an expectation object."""
        self._expect = expect

    def check(self: Self, result: TestResult) -> None:
        """Check result for a property."""
        assert self._expect in str(result), f"Could not find '{self._expect}' in:\n\n{result}"


class ExpectationRunner:
    """Manages all epectations for a given test result."""

    __test__ = False

    def __init__(self: Self, result: TestResult) -> None:
        """Make expectation runner."""
        self._result = result
        self._expectations: list[ExpectedResult] = []

    def then(self: Self, expectation: ExpectedResult) -> Self:
        """Add an expectation to manage."""
        self._expectations.append(expectation)
        return self

    def finish(self: Self) -> None:
        """Manage and assert all the expectations."""
        for each in self._expectations:
            each.check(self._result)


class TestRunner:
    """Run a Lucid interpreter test."""

    __test__ = False

    def __init__(
        self: Self,
        given: TestCase,
        policy_mapper: PolicyMapper | None = None,
        class_mapper: TrafficClassMapper | None = None,
        header_mapper: HeaderMapper | None = None,
    ) -> None:
        """Create test runner."""
        self._given = given
        self._policy_mapper = policy_mapper
        self._class_mapper = class_mapper
        self._header_mapper = header_mapper
        self._tmp_dir = None
        self._root_dir = Path(__file__).parent.parent.parent.absolute()

    def __enter__(self: Self) -> Self:
        """Enter into testing session within temp directory."""
        return self.create()

    def create(self: Self) -> Self:
        """Create a testing session."""
        self._tmp_dir = mkdtemp(prefix="tango-test-")
        src = self._root_dir / Path("src/dpt/tango")
        copytree(str(src), str(self._tmp_dir), dirs_exist_ok=True)
        return self

    def __exit__(self: Self, _: None, __: None, ____: None) -> None:
        """Destroy the testing session."""
        self.close()

    def close(self: Self) -> None:
        """Close a testing session and clean up."""
        rmtree(self._tmp_dir)

    def _create_test_file(self: Self) -> None:
        """Make the json test file."""
        if not self._tmp_dir:
            raise UsageError("Must be called within context manager!")

        config_file = Path(self._tmp_dir) / Path("test.json")
        config_file.write_text(self._given.json, encoding="utf-8")

    def _write_out_mapper(self: Self, mapper: Mapper | None = None) -> None:
        """Write out mappings to test configuration."""
        if mapper:
            path = Path(self._tmp_dir) / Path("static_maps") / Path(mapper.name)
            path.write_text(str(mapper))

    def _run_test(self: Self) -> str:
        """Run the test configuration."""
        tango_src = Path(self._tmp_dir) / Path("Tango.dpt")
        test_config = Path(self._tmp_dir) / Path("test.json")
        cmd = ["dpt", str(tango_src), "--spec", str(test_config)]

        result = run_cmd(cmd, capture_output=True, text=True, check=False)

        if result.returncode != 0:
            raise DptError(f"Lucid compiler erred with following:\n\n{result.stderr}")

        return result.stdout

    def run(self: Self) -> TestResult:
        """Execute the interpreter."""
        self._create_test_file()
        self._write_out_mapper(self._policy_mapper)
        self._write_out_mapper(self._class_mapper)
        self._write_out_mapper(self._header_mapper)
        return TestResult(self._run_test())
