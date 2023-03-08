"""Interpreter configuration models."""
from ipaddress import IPv6Address
import json
from dataclasses import dataclass
from pathlib import Path
from shutil import copytree, rmtree
from tempfile import mkdtemp
from typing import Dict, List, Optional, Self

# from subprocess import run as run_cmd, PIPE as PROC_PIPE
import docker

from edu.princeton.tango.mappers import (
    HeaderMapper,
    PolicyMapper,
    TrafficClassMapper,
)
from edu.princeton.tango.mappers.mapper import Mapper
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
from error import UsageError, TestCompileError
from events import TangoEvent


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

    def __init__(self, result: str) -> None:
        self._res = result

    def __str__(self) -> str:
        return self._res


class TestRunner:
    """Run a Lucid interpreter test."""

    def __init__(
        self,
        given: TestCase,
        policy_mapper: Optional[PolicyMapper] = None,
        class_mapper: Optional[TrafficClassMapper] = None,
        header_mapper: Optional[HeaderMapper] = None,
    ) -> None:
        self._given = given
        self._policy_mapper = policy_mapper
        self._class_mapper = class_mapper
        self._header_mapper = header_mapper
        self._tmp_dir = None
        self._root_dir = Path(__file__).parent.parent.parent.absolute()

    def __enter__(self) -> Self:
        return self.create()

    def create(self) -> Self:
        """Create a testing session."""

        self._tmp_dir = mkdtemp(prefix="tango-test-")
        print(self._tmp_dir)
        src = self._root_dir / Path("src/dpt/tango")
        copytree(str(src), str(self._tmp_dir), dirs_exist_ok=True)
        return self

    def __exit__(self, _, __, ____) -> None:
        self.close()

    def close(self) -> None:
        """Close a testing session and clean up."""

        rmtree(self._tmp_dir)

    def _create_test_file(self) -> None:
        """Make the json test file."""

        if not self._tmp_dir:
            raise UsageError("Must be called within context manager!")

        config_file = Path(self._tmp_dir) / Path("test.json")
        config_file.write_text(self._given.json, encoding="utf-8")

    def _write_out_mapper(self, mapper: Optional[Mapper] = None):
        """Write out mappings to test configuration."""

        if mapper:
            path = (
                Path(self._tmp_dir) / Path("static_maps") / Path(mapper.name)
            )
            path.write_text(str(mapper))

    def _run_test(self) -> str:
        """Run the test configuration."""

        # cmd = [
        #     "docker",
        #     "run",
        #     "-it",
        #     "--rm",
        #     "-v",
        #     f"{self._tmp_dir}:/workspace",
        #     "jsonch/lucid:lucid",
        #     'sh -c cd /workspace && /app/dpt Tango.dpt"',
        # ]
        # proc = run_cmd(cmd, stdout=PROC_PIPE, check=False)
        # out = proc.stdout.decode("utf-8")

        # if proc.returncode != 0:
        #     raise TestCompileError(out)

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

    def run(self) -> TestResult:
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
        ]
    )

    class_mapper_case = ConfiguredTrafficClassMapper(
        [
            FuzzyClassMapping(FuzzyFiveTuple(src_port=1, dest_port=1), 1),
            FuzzyClassMapping(FuzzyFiveTuple(src_port=2, dest_port=2), 2),
        ]
    )

    header_mapper_case = ConfiguredHeaderMapper(
        [
            TunnelHeader(
                0,
                IPv6Header(
                    0, 0, 0, 0, 0, 0, IPv6Address(11111), IPv6Address(22222)
                ),
            ),
            TunnelHeader(
                1,
                IPv6Header(
                    0, 0, 0, 0, 0, 0, IPv6Address(33333), IPv6Address(44444)
                ),
            ),
        ]
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
