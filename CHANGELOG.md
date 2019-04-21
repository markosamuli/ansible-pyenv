# Changelog

## [Unreleased]

### Fixed

* install on Pengwin Linux
* added Debian build requirements
* removed unused default variables

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
[1.3.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.3.0
[1.2.1]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.2.1
[1.2.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.2.0
[1.1.2]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.1.2
[1.1.1]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.1.1
[1.1.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.1.0
[1.0.0]: https://github.com/markosamuli/ansible-pyenv/releases/tag/v1.0.0
