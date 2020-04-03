# Changelog

Only the latest major version is maintained.

## [Unreleased]

Unreleased changes in the `develop` branch.

[unreleased]: https://github.com/markosamuli/ansible-pyenv/commits/develop

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
