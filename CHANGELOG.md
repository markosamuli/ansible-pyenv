# Changelog

Only the latest major version is maintained.

## [6.2.0] - 2022-04-25

Support for Ubuntu 22.04 LTS and Arch Linux. I don't have test environments for
either of these so testing is limited to the Docker environments only.

[6.2.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v6.2.0

### Fixed

- Change how tasks are included to address issues with missing homebrew action
  on Linux. ([#47][issue-47])

[issue-47]: https://github.com/markosamuli/ansible-pyenv/issues/47

### Changed

- Added tests for Ubuntu 22.04 LTS.

  Compiling Python 3.10 with Homebrew fails on Ubuntu 22.04 LTS so Homebrew
  tests are not included.

- Added configuration and tests for Arch Linux.

  Do not test Homebrew on Arch Linux as Homebrew install itself fails due to
  incorrect Ruby version.

- Default to `python3-openssl` in Ubuntu and Debian. ([#54][issue-54])

  This should work as the new default since Python 2 is EOL.

[issue-54]: https://github.com/markosamuli/ansible-pyenv/issues/54

### Development changes

- Test macOS install on GitHub Actions.
- Remove `develop` branch and pipelines.
- Support for running cross platform test images on Apple M1 devices.
- Use [`robertdebock/galaxy-action`][galaxy-action] GitHub Action to publish
  tagged releases to Ansible Galaxy once tests have been completed.

[galaxy-action]: https://github.com/robertdebock/galaxy-action

## [6.1.0] - 2022-04-15

Fix breaking changes introduced in pyenv 2.0.0.

[6.1.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v6.1.0

### Fixed

- Move PATH configuration to `.zprofile`, `.bash_profile` and `.profile` files
- Add `community.general` into collections to make `homebrew` available on new
  Ansible versions

## [6.0.0] - 2022-04-15

Use pyenv 2.2.5, Python 3.10 and add support for installing with Homebrew on
Apple M1 chips.

[6.0.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v6.0.0

### Breaking changes

- Update pyenv from 1.2.27 to 2.2.5
- Use Python 3.10 as the default version
- Do not install Python 3.8 or Python 3.9 by default
- Require Ansible 2.10

### Changed

- Add Python 3.10.3
- Update Python 3.7.9 to 3.7.13
- Update Python 3.8.9 to 3.8.13
- Update Python 3.9.4 to 3.9.11
- Run tests on the CI with Python 3.10
- Update pre-commit hooks to the latest versions

### Fixed

- Added build requirements for Debian bullseye
- Python version update script was not sorting versions correctly
- Update Homebrew installation path to `/opt/homebrew` on Apple M1 chips
- Do not try to run tests with Homebrew on Linux on ARM
- Upgrade jinja2 to 3.1.1
- Upgrade gitpython to 3.1.27
- shfmt install on CI pipelines

## [5.0.0] - 2021-05-06

New release tested with remote install on macOS and Ubuntu Linux.

[5.0.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v5.0.0

### Breaking changes

- Use Python 3.8 as the default version
- Do not install Python 3.7 automatically

### Fixed

- Do not print `docker` path in run-tests.sh
- Failing `shellcheck` pre-commit hook

### Changed

Use `pyenv` binary directly instead of loading the `.pyenvrc` file as suggested
by [@KentBrockman](https://github.com/KentBrockman) in [PR #39][pr39]. This will
allow installation of the role using remote SSH connections without the need
for interactive shell.

Remove links to Travis CI as the [tests are no longer working][travis] for
open source projects.

Remove support for old operating systems:

- Use Ubuntu 20.04 LTS as the default environment on Travis
- Remove Ubuntu 16.04 LTS tests
- Remove macOS High Sierra tests
- Remove Debian stretch tests

Improve local development setup:

- Manage development dependencies with [pip-tools]
- Use local virtualenv when running tasks in the Makefile
- Update bandit from 1.6.2 to 1.7.0

Update development dependencies with vulnerabilities:

- Update pylint from 2.5.2 to 2.7.0
- Bump jinja2 from 2.11.2 to 2.11.3

Update pyenv and Python versions:

- Install Python 3.9.4
- Update pyenv to 1.2.27
- Update default python versions to 3.7.8 and 3.8.9

[pip-tools]: https://github.com/jazzband/pip-tools
[travis]: https://github.com/markosamuli/ansible-pyenv/issues/45
[pr39]: https://github.com/markosamuli/ansible-pyenv/pull/39

## [4.0.2] - 2020-09-11

### Fixed

- Update apt cache when installing Linux dependencies to fix issue with build
  requirements failing to install on fresh installations [#37][issue37]
  ([@papierukartka][papierukartka])
- Run GitHub [Test](.github/workflows/test.yml) and
  [Code Quality](.github/workflows/code-quality.yml) workflows on `bugfix/*`
  branches and pull requests targeting the `develop` or `master` branches

[issue37]: https://github.com/markosamuli/ansible-pyenv/issues/37
[papierukartka]: https://github.com/papierukartka
[4.0.2]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v4.0.2

## [4.0.1] - 2020-09-05

This release addresses installation issues and adds additional test environments
using Docker images.

[4.0.1]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v4.0.1

### Fixed

- Run `brew into` in Ansible `shell` module instead of `command` to use the
  existing shell environment.
- Do not use Homebrew OpenSSL on Debian stretch or Ubuntu xenial to fix Python
  3.7 and 3.8 install failing due to OpenSSL not being found.
- Debian: Install `python3-openssl` instead of `python-openssl` on Debian
  buster.
- Add `black` compatible `flake8` configuration.

### Changed

Improved `run-tests.sh` script and error handling if any of the tests fail.

- Add `--debug` option to the `run-tests.sh` script that will start a
  container with an interactive shell to allow ad-hoc commands to be
  executed inside the container.

Improve the `update_test_images.py` script to allow additional options to
be provided from the command line.

- Use `click` in the `update_test_images.py` script to allow additional options
  to be provided.
- Add `--list-only` option to return the Dockerfile build target paths
  only so I can use these in my Makefile.
- Add `--distrib` option to update only images matching the specified
  Linux distribution.
- Add `--release` option to update only images matching the specified
  Linux distribution release.
- Add `--git/--no-git` option to update only images for testing the Git
  installation method.
- Add `--homebrew/--no-homebrew` option to update only for testing the
  Homebrew installation method.
- Add `--dockerfile` option to allow images to be specified by the target
  Dockerfile path. This is used by the Makefile to match existing build
  targets.

### CI: Travis

- Skip `shfmt` pre-commit hook as the CLI version is too old and causes
  issues with some formatting.

### CI: GitHub

- Test on Debian and Ubuntu using Docker images on GitHub Actions.
- Install `shfmt` via Go modules instead of using Snap packages.

## [4.0.0] - 2020-09-02

This release adds (experimental) support for installing `pyenv` via Homebrew on
Linux.

Add support and fixes for installing `pyenv` on Ubuntu 20.04 LTS and
macOS Catalina.

[4.0.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v4.0.0

### Breaking changes

- Require Python 3.6 or newer
- Require Ansible 2.8 or newer

### Homebrew on Linux

The main purpose of this feature is to allow testing of the Homebrew
installation on my Windows and Linux development environments inside
Ubuntu and Debian Docker containers.

This should be considered experimental and not the preferred way to
install pyenv on Linux as it comes with a few quirks.

To address known issue with pyenv on Homebrew on Linux, the Homebrew
readline package is automatically uninstalled and then reinstalled
while building Python versions with this role.

### Changed

- Install `pyenv` with Homebrew on Linux
- Upgrade `ansible-lint` to v4.3.3
- Add missing directory permissions to ensure compatibility with the future
  Ansible versions.

### Fixed

- Ubuntu: Add missing `libncursesw5-dev` dependency
- Ubuntu: Install openssl when installing via Homebrew
- Fix issue with first time Python installs failing as pyenv has not been
  set up in the user's shell profile.
- macOS: Ensure `gcc` is installed as recommended by Homebrew installer
- Add permissions to the Git repositories while cloning as the default file and
  directory permissions will change in the future Ansible versions.

### CI: Travis

- Run preferred OS builds first
- macOS: Run test builds on macOS 10.15 (Catalina)
- Ubuntu: Use Ansible 2.12 `auto` detection on Ubuntu 20.04 LTS instead of the
  `auto_legacy` detection from Ansible 2.8 to detect the Python 3 version
  correctly.
- Ubuntu: Remove Ubuntu 18.04 LTS Ansible 2.9 build
- Use Ubuntu 20.04 LTS for running `pre-commit` tests

### CI: pre-commit

- Upgrade to `pre-commit` v2.7.0
- Format Python code with black
- Lint Python files with flake8 and pylint
- Test Python files for security issues with bandit
- Add pylint config compatible with black code formatting
- Add Python development dependencies into requirements.dev.txt

### CI: GitHub

- Use the latest Python 3.x version for running tests

### CI: Tests with Docker images

- Update Docker images with Python and Jinja2 templates
- Add Ubuntu 20.04 LTS support
- Do not store test Docker image files in the repository
- Add support for running tests on WSL2
- Install `procps` on Homebrew test images
- Fix missing script permissions caused development environment on Windows FS

## [3.0.2] - 2020-08-29

### Changed

- Update to [pyenv 1.2.20][pyenv-1220]
- Update to [Python 3.7.8][python-378]
- Update to [Python 3.8.5][python-385]

[pyenv-1220]: https://github.com/pyenv/pyenv/releases/tag/v1.2.20
[python-378]: https://www.python.org/downloads/release/python-378/
[python-385]: https://www.python.org/downloads/release/python-385/
[3.0.2]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v3.0.2

## [3.0.1] - 2020-04-03

### Changed

- Update to [pyenv 1.2.18][pyenv-1218]
- Update to [Python 3.7.7][python-377]
- Update to [Python 3.8.2][python-382]

[pyenv-1218]: https://github.com/pyenv/pyenv/releases/tag/v1.2.18
[python-377]: https://www.python.org/downloads/release/python-377/
[python-382]: https://www.python.org/downloads/release/python-382/
[3.0.1]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v3.0.1

## [3.0.0] - 2020-02-08

### Changed

- Update to [pyenv 1.2.16][pyenv-1216]
- Update to [Python 3.7.6][python-376]
- Install [Python 3.8.1][python-381]
- New variables `pyenv_python37_version` and `pyenv_python38_version`
- Removed `pyenv_python2_version` and `pyenv_python3_version` variables
- Removed macOS Mojave patch support
- Test with Ansible 2.9 on Travis CI
- Remove Ansible 2.6 support and tests on Travis CI

[pyenv-1216]: https://github.com/pyenv/pyenv/releases/tag/v1.2.16
[python-376]: https://www.python.org/downloads/release/python-376/
[python-381]: https://www.python.org/downloads/release/python-381/
[3.0.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v3.0.0

### Python 2 support

[Python 2][sunset-python-2] has reached end of life on January 1, 2020.

This role will no longer install Python 2.7 by default.

You can use the previous [2.1.1] version or customise the installed versions.

[sunset-python-2]: https://www.python.org/doc/sunset-python-2/

### Python 3 support

This version adds Python 3.8 to installed versions.

The default `global` version is set to Python 3.7.

## [2.1.1] - 2019-11-20

### Changed

- Update to [pyenv 1.2.15][pyenv-1215]
- Update to [Python 2.7.17][python-2717]
- Update to [Python 3.7.5][python-375]

[pyenv-1215]: https://github.com/pyenv/pyenv/releases/tag/v1.2.15
[python-2717]: https://www.python.org/downloads/release/python-2717/
[python-375]: https://www.python.org/downloads/release/python-375/

### Development improvements

- Improvements to development and test bash scripts
- Remove Xcode 10.21.1, 10.3 and 11.0 builds on macOS 10.14
- Do not install Ansible 2.8.6 when running tests

## [2.1.0] - 2019-11-03

### macOS Mojave support

This released has a patch for older Mojave releases, but as the defaults seem
to be working again (at least with the Command LIne Tools), I've disabled this
in the default configuration.

Apple security certificates on Travis have expired so installing the macOS SDK
headers on the CI pipelines doesn't currently work.

## [2.1.0-rc.2] - 2019-11-03

### Changed

- Update pyenv 1.2.13 -> 1.2.14
- Added Xcode 10.3 and Xcode 11.2 test images on Travis
- Removed macOS Git install test jobs on Travis

### Fixed

- Do no install macOS SDK headers on Mojave
- Support for BSD sed in `update-python` and `update-release` scripts

## [2.1.0-rc.1] - 2019-07-19

### Changes

- Update pyenv 1.2.11 -> 1.2.13
- Update Python 3.7.3 -> 3.7.4
- Added Xcode 11.0 test image on Travis
- Remove Homebrew packages if using Git installation method

### Fix Python installation on macOS Mojave

The role sets `MACOSX_DEPLOYMENT_TARGET` and `SDKROOT` environment variables
when installing new Python versions on macOS Mojave.

This fixes [issue #16] when installing Python versions within the Ansible role.

### Use Homebrew as the default installation method on macOS

The Git-based install was enabled to address [issue #16] on macOS Mojave with
the pyenv version pinned down to version 1.2.11. Using an old pyenv version
prevents user from installing the latest Python.

The installation issues with macOS Mojave been been fixed, so I've changed the
default installation method back to using Homebrew packages.

The role doesn't know how to migrate from existing Homebrew installs to
Git-based installations, so it will try to detect any existing installation
and keep using the previous method.

## [2.0.0] - 2019-06-25

### Changed

- Use the Git repository installation method instead of Homebrew packages
  on macOS.

### Fixed

- Fix deprecation warnings when running role with Ansible 2.8.
- Load shell completions only if `.pyenvrc` is found.
- Load shell completions from Homebrew directory on macOS.

### CI/CD

- Define build matrix in job definitions as build stages do not support
  matrix.include configuration.
- Add Bionic to Ubuntu build images.
- Update apt cache on Ubuntu jobs.
- Use minimal image for pre-commit stage jobs.
- Remove python version variable when using generic images as it doesn't
  have any effect.
- Remove duplicate Ansible versions.

## [1.5.1] - 2019-06-09

### Fixed

- Do not set 'system' in global version if it's not available

## [1.5.0] - 2019-06-03

### Changed

- Set global python version to `2.7.16 3.7.3 system`
- Run Debian and Ubuntu tests in Docker containers with Ansible v2.7
- Drop support for unsupported Ansible v2.4 and v2.5 versions
- Drop support for macOS 10.12 and Xcode 9.4

### Fixed

- Load zsh and bash completions only if installed
- OS variable loading breaking with conflicting playbooks

## [1.4.0] - 2019-04-22

### Changed

- changed Python version variables structure so that they're easier to update
- update Python 2.7.16 -> 2.7.16
- update Python 3.7.2 -> 3.7.3
- install latest Python 3.7 as the default global version

### Fixed

- install on Pengwin Linux
- added Debian build requirements
- removed unused default variables
- tests inside Docker containers on WSL

## [1.3.0] - 2019-04-20

### Fixed

- `update-release` script needs repository to update

### Changed

- updated [pyenv] from v1.2.9 to v1.2.11
- drop Trusty support and builds

## [1.2.1] - 2019-03-03

- improved update-python script
- coding style changes

## [1.2.0] - 2019-02-27

- add support for macOS 10.14
- drop Ansible < 2.4 support
- install macOS SDK headers for macOS 10.14

## [1.1.2] - 2019-02-17

- install Python 3.7.2

## [1.1.1] - 2019-02-17

- updated [pyenv-virtualenv] from v1.1.3 to v1.1.5

[pyenv-virtualenv]: https://github.com/pyenv/pyenv-virtualenv

## [1.1.0] - 2019-01-13

- optionally install [pyenv-virtualenvwrapper]
- updated [pyenv] from v1.2.8 to v1.2.9
- add GitHub access token to `update-release` script

[pyenv]: https://github.com/pyenv/pyenv
[pyenv-virtualenvwrapper]: https://github.com/pyenv/pyenv-virtualenvwrapper

## [1.0.0] - 2018-12-04

- create .pyenvrc file in ~/.pyenv and load this in .bashrc and .zshrc files
- install Python versions
- set pyenv global version

[2.1.1]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v2.1.1
[2.1.1]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v2.1.1
[2.1.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v2.1.0
[2.1.0-rc.2]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v2.1.0-rc.2
[2.1.0-rc.1]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v2.1.0-rc.1
[2.0.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v2.0.0
[1.5.1]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.5.1
[1.5.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.5.0
[1.4.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.4.0
[1.3.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.3.0
[1.2.1]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.2.1
[1.2.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.2.0
[1.1.2]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.1.2
[1.1.1]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.1.1
[1.1.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.1.0
[1.0.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.0.0
[issue #16]: https://github.com/markosamuli/ansible-pyenv/issues/16
