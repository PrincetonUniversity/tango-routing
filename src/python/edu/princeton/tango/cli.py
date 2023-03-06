import click

from edu.princeton.tango.config_parser import ConfigParser, DefaultConfigParser


@click.group()
def cli():
    """Tango base command"""


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
def config(file: str, default: bool):
    """Configure Tango given a YAML file."""

    if default:
        configs = DefaultConfigParser()
    else:
        configs = ConfigParser(file)

    with open("headers.dpt", "w+", encoding="utf-8") as file:
        file.write(str(configs.header_mapper))
    with open("mappings.dpt", "w+", encoding="utf-8") as file:
        file.write(str(configs.class_mapper))
    with open("policies.dpt", "w+", encoding="utf-8") as file:
        file.write(str(configs.policy_mapper))


if __name__ == "__main__":
    cli()
