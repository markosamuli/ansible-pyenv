# markosamuli.pyenv

[![Ansible Quality Score](https://img.shields.io/ansible/quality/38342.svg)](https://galaxy.ansible.com/markosamuli/pyenv)
[![Ansible Role](https://img.shields.io/ansible/role/38342.svg)](https://galaxy.ansible.com/markosamuli/pyenv)
[![GitHub release](https://img.shields.io/github/release/markosamuli/ansible-pyenv.svg)](https://github.com/markosamuli/ansible-pyenv/releases)
[![License](https://img.shields.io/github/license/markosamuli/ansible-pyenv.svg)](https://github.com/markosamuli/ansible-pyenv/blob/master/LICENSE)

| Branch  | Travis Builds                             | Code Quality                |
| ------- | ----------------------------------------- | --------------------------- |
| master  | [![Build Status][travis-master]][travis]  | ![Build Status][gh-master]  |
| develop | [![Build Status][travis-develop]][travis] | ![Build Status][gh-develop] |

[travis]: https://travis-ci.org/markosamuli/ansible-pyenv/branches
[travis-master]: https://travis-ci.org/markosamuli/ansible-pyenv.svg?branch=master
[travis-develop]: https://travis-ci.org/markosamuli/ansible-pyenv.svg?branch=develop
[gh-master]: https://github.com/markosamuli/ansible-pyenv/workflows/Code%20Quality/badge.svg?branch=master
[gh-develop]: https://github.com/markosamuli/ansible-pyenv/workflows/Code%20Quality/badge.svg?branch=develop

Ansible role to install [pyenv] and [pyenv-virtualenv] on Ubuntu or macOS
development machines.

Optionally, [pyenv-virtualenvwrapper] can be installed and used for managing
environments.

Don't use this role on production servers as it supports installing pyenv only
under user home directory.

[pyenv]: https://github.com/pyenv/pyenv
[pyenv-virtualenv]: https://github.com/pyenv/pyenv-virtualenv
[pyenv-virtualenvwrapper]: https://github.com/pyenv/pyenv-virtualenvwrapper

## Install from Homebrew on macOS

The default method to install pyenv and plugins on macOS is to use Homebrew.

The role doesn't know how to migrate from existing Homebrew installs to
Git-based installations, so it will try to detect any existing installation
and keep using the previous method.

If you want to migrate, backup and delete your existing `~/.pyenv` directory
before running this role.

## Installed Python versions

This role installs [Python][python] versions defined in `pyenv_python_versions`
variable.

To set global version, set `pyenv_global` variable to the desired version(s).

```yaml
pyenv_global: "{{ pyenv_python37_version }} system"
```

This is configured to use latest Python 2 and Python 3 versions and the
system version as default.

[python]: https://www.python.org

## Changes to shell config files

This role creates config file in `~/.pyenv/.pyenvrc` that is loaded in
`.bashrc` and `.zshrc` files.

Code completion is loaded by default.

If you're managing your shell scripts `.dotfiles` or are using a framework, you
should set `pyenv_init_shell` to `false` and update these files yourself to keep
them clean.

Reference `.bashrc` configuration:

```bash
if [ -e "$HOME/.pyenv/.pyenvrc" ]; then
  source $HOME/.pyenv/.pyenvrc
  if [ -e "$HOME/.pyenv/completions/pyenv.bash" ]; then
    source $HOME/.pyenv/completions/pyenv.bash
  elif [ -e "/usr/local/opt/pyenv/completions/pyenv.bash" ]; then
    source /usr/local/opt/pyenv/completions/pyenv.bash
  fi
fi
```

Reference `.zshrc` configuration:

```zsh
if [ -e "$HOME/.pyenv/.pyenvrc" ]; then
  source $HOME/.pyenv/.pyenvrc
  if [ -e "$HOME/.pyenv/completions/pyenv.zsh" ]; then
    source $HOME/.pyenv/completions/pyenv.zsh
  elif [ -e "/usr/local/opt/pyenv/completions/pyenv.zsh" ]; then
    source /usr/local/opt/pyenv/completions/pyenv.zsh
  fi
fi
```

## Role Variables

Path to `~/.pyenv` is based on environment variables:

```yaml
# Installation paths
pyenv_home: "{{ ansible_env.HOME }}"
pyenv_root: "{{ ansible_env.HOME }}/.pyenv"
```

Update `.bashrc` and `.zshrc` files in user home directory:

```yaml
# Update .bashrc and .zshrc shell scripts
pyenv_init_shell: true
```

Versions to install.

```yaml
# Versions to install
pyenv_version: "v1.2.13"
pyenv_virtualenv_version: "v1.1.5"
pyenv_virtualenvwrapper_version: "v20140609"
```

Latest Python 2 and Python 3 versions are installed:

```yaml
# Latest Python versions
pyenv_python37_version: "3.7.6"
pyenv_python38_version: "3.8.1"

# Python versions to install
pyenv_python_versions:
  - "{{ pyenv_python37_version }}"
  - "{{ pyenv_python38_version }}"
```

Set global version:

```yaml
# Set global pyenv version
pyenv_global: "{{ pyenv_python37_version }} system"
```

Install virtualenvwrapper plugin:

```yaml
# Optionally, install virtualenvwrapper plugin for pyenv
pyenv_virtualenvwrapper: false
pyenv_virtualenvwrapper_home: "{{ ansible_env.HOME }}/.virtualenvs"
```

Install using Homebrew on macOS:

```yaml
# Install using package manager where available
pyenv_install_from_package_manager: false
```

Detect existing installation method and use that:

```yaml
# Detect existing install
pyenv_detect_existing_install: true
```

## Example Playbook

```yaml
- hosts: localhost
  connection: local
  become: false
  roles:
    - role: markosamuli.pyenv
```

## Updating versions

Run the following scripts to get latest releases from GitHub and update them in
role defaults.

Update [pyenv] release:

```bash
./update-release pyenv
```

Update [pyenv-virtualenv] release:

```bash
./update-release pyenv-virtualenv
```

Update default [Python] 3.7 version:

```bash
./update-python python37
```

Update default [Python] 3.8 version:

```bash
./update-python python38
```

Update all versions:

```bash
make update
```

## Coding style

Install pre-commit hooks and validate coding style:

```bash
make lint
```

## Run tests

Run tests in Ubuntu and Debian using Docker:

```bash
make test
```

## Acknowledgements

Use of `.pyenvrc` file and parts used for installing python version taken from
[avanov.pyenv](https://github.com/avanov/ansible-galaxy-pyenv) role.

## Development

Install [pre-commit] hooks:

```bash
make install-git-hooks
```

[pre-commit]: https://pre-commit.com/

## Changes

- [CHANGELOG.md](CHANGELOG.md)

## License

- [MIT](LICENSE)

## Author Information

- [@markosamuli](https://github.com/markosamuli)
