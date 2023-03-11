"""Interpreter configuration models."""
import json
from dataclasses import dataclass
from ipaddress import IPv6Address
from pathlib import Path
from shutil import copytree, rmtree
from tempfile import mkdtemp
from typing import TYPE_CHECKING, Self

import docker
from edu.princeton.tango.mappers.policy_mapper import (
    ConfiguredPolicyMapper,
    OptimizationStrategy,
    Policy,
)
from edu.princeton.tango.mappers.traffic_class_mapper import (
    ConfiguredTrafficClassMapper,
    FuzzyClassMapping,
    FuzzyFiveTuple,
)
from edu.princeton.tango.mappers.tunnel_header_mapper import (
    ConfiguredHeaderMapper,
    IPv6Header,
    TunnelHeader,
)
from error import TestCompileError, UsageError
from events import TangoEvent

if TYPE_CHECKING:
    from edu.princeton.tango.mappers import (
        HeaderMapper,
        PolicyMapper,
        TrafficClassMapper,
    )
    from edu.princeton.tango.mappers.mapper import Mapper


@dataclass
class EventLocation:
    """Tie router id and port together as a location."""

    router_id: int
    port: int

    def __str__(self: Self) -> str:
        """Convert to expected formatted string."""
        return f"{self.router_id}:{self.port}"


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

    def __init__(
        self: Self,
        event: TangoEvent,
        timestamp: int | None = None,
        locations: list[EventLocation] | None = None,
    ) -> None:
        """Create a test event."""
        self._event = event
        self._timestamp = timestamp
        self._locations = locations

    def as_dict(self: Self) -> dict[str, str]:
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
    def json(self: Self) -> str:
        """Get test case in json string form."""
        return json.dumps(self.as_dict())


class ExpectedResult:
    """Expected result of an interpreter test."""

    # TODO: IMPLEMENT


class TestResult:
    """Result of an interpreter run."""

    def __init__(self: Self, result: str) -> None:
        """Create a Test Result."""
        self._res = result

    def __str__(self: Self) -> str:
        """Give back the raw string form of the interpreter output."""
        return self._res


class TestRunner:
    """Run a Lucid interpreter test."""

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
        print(self._tmp_dir)
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

    def _write_out_mapper(self, mapper: Mapper | None = None) -> None:
        """Write out mappings to test configuration."""
        if mapper:
            path = (
                Path(self._tmp_dir) / Path("static_maps") / Path(mapper.name)
            )
            path.write_text(str(mapper))

    def _run_test(self: Self) -> str:
        """Run the test configuration."""
        client = docker.from_env()
        try:
            return client.containers.run(
                image="jsonch/lucid:lucid",
                auto_remove=True,
                volumes=[f"{self._tmp_dir}:/workspace"],
                command='sh -c "cd /workspace && /app/dpt Tango.dpt"',
            ).decode("utf-8")
        except Exception as err:
            raise TestCompileError(err) from err

    def run(self: Self) -> TestResult:
        """Execute the interpreter."""
        self._create_test_file()
        self._write_out_mapper(self._policy_mapper)
        self._write_out_mapper(self._class_mapper)
        self._write_out_mapper(self._header_mapper)
        return TestResult(self._run_test())


if __name__ == "__main__":
    from events import ForwardFlow
    from tango_types import EthernetHeader, FiveTuple, IPv4Header

    events = [
        ForwardFlow(
            EthernetHeader(0, 1, 2),
            IPv4Header(3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
            FiveTuple(13, 14, 15, 16, 17),
        ),
        ForwardFlow(
            EthernetHeader(10, 11, 12),
            IPv4Header(13, 14, 15, 16, 17, 18, 19, 110, 111, 112),
            FiveTuple(113, 114, 115, 116, 117),
        ),
    ]

    links = [EventLink(EventLocation(0, 1), EventLocation(1, 0))]

    # given_case = TestCase(99999, events, switches=2, link_list=links)
    given_case = TestCase(99999, [])

    policy_mapper_case = ConfiguredPolicyMapper(
        [
            Policy(0, OptimizationStrategy.OPTIMIZE_DELAY),
            Policy(1, OptimizationStrategy.OPTIMIZE_LOSS),
        ],
    )

    class_mapper_case = ConfiguredTrafficClassMapper(
        [
            FuzzyClassMapping(FuzzyFiveTuple(src_port=1, dest_port=1), 1),
            FuzzyClassMapping(FuzzyFiveTuple(src_port=2, dest_port=2), 2),
        ],
    )

    header_mapper_case = ConfiguredHeaderMapper(
        [
            TunnelHeader(
                0,
                IPv6Header(
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    IPv6Address(11111),
                    IPv6Address(22222),
                ),
            ),
            TunnelHeader(
                1,
                IPv6Header(
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    IPv6Address(33333),
                    IPv6Address(44444),
                ),
            ),
        ],
    )

    with TestRunner(
        given_case,
        # policy_mapper=policy_mapper_case,
        # class_mapper=class_mapper_case,
        # header_mapper=header_mapper_case,
    ) as runner:
        print(runner.run())
    # TestRunner(
    #     given_case,
    #     # policy_mapper=policy_mapper_case,
    #     # class_mapper=class_mapper_case,
    #     # header_mapper=header_mapper_case,
    # ).create().run()
