"""Command-line tool enabling simple interactions with Tango."""
from pathlib import Path

import click
from edu.princeton.tango.config_parser import DefaultConfigParser, YAMLConfigParser
from edu.princeton.tango.ipv6_to_lucid import convert_ipv6_to_lucid


@click.group()
def cli() -> None:
    """Tango base command."""


def get_out_path(file: str, prefix: str | None = None) -> Path:
    """Get output path for a given gerneated file."""
    return Path(prefix) / Path(file) if prefix else Path(file)


@cli.command()
@click.option(
    "--file",
    type=click.Path(exists=True),
    help="YAML file configuring Tango.",
    required=False,
)
@click.option(
    "--default",
    is_flag=True,
    default=False,
    help="Restore placeholder files.",
    required=False,
)
@click.option(
    "--prefix",
    type=click.Path(),
    default=".",
    help="Directory prefix for output files.",
    required=False,
)
def config(
    file: str,
    default: bool | None = None,
    prefix: str | None = None,
) -> None:
    """Configure Tango given a YAML file."""
    configs = DefaultConfigParser() if default else YAMLConfigParser(file)

    if prefix:
        Path(prefix).mkdir(exist_ok=True, parents=True)

    get_out_path("TunnelHeaderMap.dpt", prefix).write_text(
        str(configs.header_mapper),
        encoding="utf-8",
    )

    get_out_path("TrafficClassMap.dpt", prefix).write_text(
        str(configs.class_mapper),
        encoding="utf-8",
    )

    get_out_path("TrafficClassOpmizationMap.dpt", prefix).write_text(
        str(configs.policy_mapper),
        encoding="utf-8",
    )

    get_out_path("TrafficClassConstraintMap.dpt", prefix).write_text(
        str(configs.constraint_mapper),
        encoding="utf-8",
    )


@cli.command()
@click.option(
    "--file",
    type=click.Path(exists=True),
    help="List file containing IPv6 Addresses to convert.",
    required=True,
)
def addrconv(file: str) -> None:
    """Convert a list of IPv6 Addresses to lucid format."""
    convert_ipv6_to_lucid(Path(file))


if __name__ == "__main__":
    cli()
