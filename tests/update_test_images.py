#!/usr/bin/env python3
"""
Update Docker test images
"""

import os
import stat
from pathlib import Path
from shutil import copyfile
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


def main():
    """
    Generate Docker images for supported Ubuntu and Debian releases
    """

    ubuntu_python3_releases = ["focal"]
    for tag in ubuntu_python3_releases:
        update_dockerfile("ubuntu", tag, python="python3")
        update_dockerfile_with_homebrew("ubuntu", tag, python="python3")

    ubuntu_releases = ["xenial", "bionic"]
    for tag in ubuntu_releases:
        update_dockerfile("ubuntu", tag)
        update_dockerfile_with_homebrew("ubuntu", tag)

    debian_releases = ["stretch", "buster"]
    for tag in debian_releases:
        update_dockerfile("debian", tag)
        update_dockerfile_with_homebrew("debian", tag)


if __name__ == "__main__":
    main()
