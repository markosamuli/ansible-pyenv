#!/usr/bin/env python3
"""
Update Docker test images
"""

import os
import stat
from pathlib import Path
from shutil import copyfile
from typing import Iterable, Tuple

import click
from jinja2 import Environment, FileSystemLoader, select_autoescape

FILE = Path(__file__).resolve()
TESTS_DIR, PROJECT_ROOT = FILE.parent, FILE.parents[1]

TEMPLATES_DIR = os.path.join(TESTS_DIR, "templates")
IMAGES_DIR = os.path.join(TESTS_DIR, "images")

TEST_USER = "test"
REPOSITORY = os.path.basename(PROJECT_ROOT)
ANSIBLE_VERSION = "<2.9.0,!=2.8.6"

env = Environment(
    autoescape=select_autoescape(["html", "htm", "xml"]),
    loader=FileSystemLoader(TEMPLATES_DIR),
)


def create_dockerfile(
    docker_image: str,
    docker_tag: str,
    install_homebrew: bool = False,
    python: str = None,
):
    """
    Create Dockerfile in the target directory
    """
    target_dir = docker_tag
    if install_homebrew:
        target_dir = f"{target_dir}-with-homebrew"

    target_dir = os.path.join(IMAGES_DIR, target_dir)
    target_file = os.path.join(target_dir, "Dockerfile")

    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    ctx = {
        "from": f"{docker_image}:{docker_tag}",
        "user": TEST_USER,
        "repository": REPOSITORY,
        "ansible_version": ANSIBLE_VERSION,
        "install_homebrew": install_homebrew,
        "python": python,
    }

    print(f"*** Updating {target_file}")

    template = env.get_template("Dockerfile.jinja2")
    dockerfile_data = template.render(ctx)
    with open(target_file, "w", encoding="utf-8") as dockerfile:
        dockerfile.write(dockerfile_data)

    scripts = []

    if install_homebrew:
        scripts.append("install_homebrew.sh")

    if scripts:
        for script in scripts:
            print(f"*** Add {script}")
            src_script = os.path.join(TEMPLATES_DIR, script)
            dst_script = os.path.join(target_dir, script)
            copyfile(src_script, dst_script)
            os.chmod(dst_script, stat.S_IXUSR | stat.S_IRUSR | stat.S_IWUSR)


def update_dockerfile(docker_image: str, docker_tag: str, python: str = None):
    """
    Generate Dockerfile
    """
    create_dockerfile(docker_image, docker_tag, python=python)


def update_dockerfile_with_homebrew(
    docker_image: str, docker_tag: str, python: str = None
):
    """
    Generate Dockerfile with Homebrew installation
    """
    create_dockerfile(
        docker_image,
        docker_tag,
        python=python,
        install_homebrew=True,
    )


DEBIAN = "debian"
UBUNTU = "ubuntu"

images = {
    "debian": {"stretch": {}, "buster": {}},
    "ubuntu": {"focal": {"python": "python3"}, "xenial": {}, "bionic": {}},
}


def list_distributions() -> Iterable[str]:
    """
    List available distributions
    """
    return images.keys()


def list_releases() -> Iterable[str]:
    """
    List available releases
    """
    releases = []
    for distrib_releases in images.values():
        for release in distrib_releases.keys():
            releases.append(release)
    return releases


def parse_dockerfile(dockerfile) -> Tuple[str, str, str]:
    """
    Parse build target information from the Dockerfile path
    """
    git = True
    homebrew = False
    image = dockerfile.replace("tests/images/", "").replace("/Dockerfile", "")
    if "-with-homebrew" in image:
        image = image.replace("-with-homebrew", "")
        git = False
        homebrew = True
    if image not in list_releases():
        raise ValueError(f"invalid build target {dockerfile}")
    return image, git, homebrew


@click.command()
@click.option(
    "--distrib", type=click.Choice(list_distributions(), case_sensitive=False)
)
@click.option("--release", type=click.Choice(list_releases(), case_sensitive=False))
@click.option("--git/--no-git", default=True)
@click.option("--homebrew/--no-homebrew", default=True)
@click.option("--dockerfile", type=str)
def update_test_images(
    distrib: str, release: str, git: bool, homebrew: bool, dockerfile: str
):
    """
    Generate Docker images for supported Ubuntu and Debian releases
    """

    if dockerfile:
        release, git, homebrew = parse_dockerfile(dockerfile)

    for image, releases in images.items():
        if distrib and image != distrib:
            continue
        for tag, config in releases.items():
            if release and tag != release:
                continue
            if git:
                update_dockerfile(image, tag, **config)
            if homebrew:
                update_dockerfile_with_homebrew(image, tag, **config)


if __name__ == "__main__":
    update_test_images()  # pylint: disable=no-value-for-parameter
