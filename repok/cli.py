from importlib import metadata

import click


@click.group()
def repok():
    """Check that repo is OK"""


@repok.command()
def version():
    version = metadata.version("repok")
    click.echo(f"repok version {version}")


if __name__ == "__main__":
    repok()
