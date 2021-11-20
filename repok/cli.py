
import click

@click.group()
def repok():
    """GitHub Action"""

@repok.command()
def version():
    click.echo("Version!")

if __name__ == '__main__':
    repok()