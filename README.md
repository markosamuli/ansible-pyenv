# markosamuli.pyenv

[![Ansible Quality Score](https://img.shields.io/ansible/quality/38342.svg)](https://galaxy.ansible.com/markosamuli/pyenv)
[![Ansible Role](https://img.shields.io/ansible/role/38342.svg)](https://galaxy.ansible.com/markosamuli/pyenv)
[![GitHub release](https://img.shields.io/github/release/markosamuli/ansible-pyenv.svg)](https://github.com/markosamuli/ansible-pyenv/releases)
[![License](https://img.shields.io/github/license/markosamuli/ansible-pyenv.svg)](https://github.com/markosamuli/ansible-pyenv/blob/master/LICENSE)

| Branch | Pipeline                                    |
| ------ | ------------------------------------------- |
| master | [![master][status-master]][pipeline-master] |

[pipeline-master]: https://github.com/markosamuli/ansible-pyenv/actions/workflows/pipeline.yml?query=branch%3Amaster
[status-master]: https://github.com/markosamuli/ansible-pyenv/workflows/Test%20and%20release/badge.svg?branch=master

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

## Install from Homebrew on Linux

The role includes an experimental support for installing pyenv and plugins
with Homebrew on Linux.

The role doesn't install Homebrew on Linux itself and expects it to be installed
in the default `/home/linuxbrew/.linuxbrew` location.

Installing Python versions with pyenv on Linux when Homebrew installation exists
has some known issues:

- readline extension was not compiled, installed pyenv by Linuxbrew on
  Ubuntu 16 [#1479][pyenv-1479]

[pyenv-1479]: https://github.com/pyenv/pyenv/issues/1479

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
pyenv_home: "{{ ansible_env.HOME }}"
pyenv_root: "{{ ansible_env.HOME }}/.pyenv"
```

Update `.bashrc` and `.zshrc` files in user home directory:

```yaml
pyenv_init_shell: true
```

Versions to install:

```yaml
pyenv_version: "v1.2.13"
pyenv_virtualenv_version: "v1.1.5"
pyenv_virtualenvwrapper_version: "v20140609"
```

Latest Python 3.7 and Python 3.8 versions:

```yaml
pyenv_python37_version: "3.7.6"
pyenv_python38_version: "3.8.1"
```

Python 2 and Python 3 versions are installed by default:

```yaml
pyenv_python_versions:
  - "{{ pyenv_python37_version }}"
  - "{{ pyenv_python38_version }}"
```

Set global version to Python 3.7 with `system` fallback:

```yaml
pyenv_global: "{{ pyenv_python37_version }} system"
```

Install virtualenvwrapper plugin:

```yaml
pyenv_virtualenvwrapper: false
pyenv_virtualenvwrapper_home: "{{ ansible_env.HOME }}/.virtualenvs"
```

Install using Homebrew package manager on macOS:

```yaml
pyenv_install_from_package_manager: true
```

Detect existing installation method and use that:

```yaml
pyenv_detect_existing_install: true
```

Install using Homebrew on Linux:

```yaml
pyenv_homebrew_on_linux: true
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

Install development dependencies in a local virtualenv:

```bash
make setup
```

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
