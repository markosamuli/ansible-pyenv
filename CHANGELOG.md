# Changelog

## [1.5.1] - 2019-06-09

### Fixed

* Do not set 'system' in global version if it's not available

## [1.5.0] - 2019-06-03

### Changed

* Set global python version to `2.7.16 3.7.3 system`
* Run Debian and Ubuntu tests in Docker containers with Ansible v2.7
* Drop support for unsupported Ansible v2.4 and v2.5 versions
* Drop support for macOS 10.12 and Xcode 9.4

### Fixed

* Load zsh and bash completions only if installed
* OS variable loading breaking with conflicting playbooks

## [1.4.0] - 2019-04-22

### Changed

* changed Python version variables structure so that they're easier to update
* update Python 2.7.16 -> 2.7.16
* update Python 3.7.2 -> 3.7.3
* install latest Python 3.7 as the default global version

### Fixed

* install on Pengwin Linux
* added Debian build requirements
* removed unused default variables
* tests inside Docker containers on WSL

## [1.3.0] - 2019-04-20

### Fixed

* `update-release` script needs repository to update

### Changed

* updated [pyenv] from v1.2.9 to v1.2.11
* drop Trusty support and builds

## [1.2.1] - 2019-03-03

* improved update-python script
* coding style changes

## [1.2.0] - 2019-02-27

* add support for macOS 10.14
* drop Ansible < 2.4 support
* install macOS SDK headers for macOS 10.14

## [1.1.2] - 2019-02-17

* install Python 3.7.2

## [1.1.1] - 2019-02-17

* updated [pyenv-virtualenv] from v1.1.3 to v1.1.5

[pyenv-virtualenv]: https://github.com/pyenv/pyenv-virtualenv

## [1.1.0] - 2019-01-13

* optionally install [pyenv-virtualenvwrapper]
* updated [pyenv] from v1.2.8 to v1.2.9
* add GitHub access token to `update-release` script

[pyenv]: https://github.com/pyenv/pyenv
[pyenv-virtualenvwrapper]: https://github.com/pyenv/pyenv-virtualenvwrapper

## [1.0.0] - 2018-12-04

* create .pyenvrc file in ~/.pyenv and load this in .bashrc and .zshrc files
* install Python versions
* set pyenv global version

[Unreleased]: https://github.com/markosamuli/ansible-pyenv/commits/develop
[1.4.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.4.0
[1.3.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.3.0
[1.2.1]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.2.1
[1.2.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.2.0
[1.1.2]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.1.2
[1.1.1]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.1.1
[1.1.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.1.0
[1.0.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.0.0
