# markosamuli.pyenv

[![Build Status](https://travis-ci.org/markosamuli/ansible-pyenv.svg?branch=master)](https://travis-ci.org/markosamuli/ansible-pyenv)
[![GitHub release](https://img.shields.io/github/release/markosamuli/ansible-pyenv.svg)](https://github.com/markosamuli/ansible-pyenv/releases)
[![License](https://img.shields.io/github/license/markosamuli/ansible-pyenv.svg)](https://github.com/markosamuli/ansible-pyenv/blob/master/LICENSE)

Ansible role to install [pyenv](https://github.com/pyenv/pyenv) and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) on Ubuntu or macOS development machines.

Optionally, [pyenv-virtualenvwrapper](https://github.com/pyenv/pyenv-virtualenvwrapper) can be installed and used for managing environments.

Don't use this role on production servers as it supports installing pyenv only under
user home directory.

This role installs Python versions defined in `pyenv_python_versions` variable.

To set global version, set `pyenv_global` variable to the desired version. By default
this is not configured.

This role creates config file in `~/.pyenv/.pyenvrc` that is loaded in `.bashrc`
and `.zshrc` files.

Autocomplete is loaded by default.

## Role Variables

```yaml
# Versions to install
pyenv_version: "v1.2.9"
pyenv_virtualenv_version: "v1.1.5"

# Initialize shell profile scripts
pyenv_init_shell: yes

# Python versions to install
pyenv_python_versions:
  - "2.7.15"
  - "3.7.2"

# Set global pyenv version
pyenv_global: "3.7.2"

# Define the shell profile scripts to initialiaze
pyenv_shell_profile_scripts:
  - .bashrc
  - .zshrc

# Optionally, install virtualenvwrapper plugin for pyenv
pyenv_virtualenvwrapper: no
```

## Example Playbook

```yaml
- hosts: localhost
  connection: local
  roles:
      - { role: markosamuli.pyenv }
```

## Updating versions

Run the following script to get latest releases from GitHub and update them in
role defaults.

```bash
./update-release
```

## Acknowledgments

Use of `.pyenvrc` file and parts used for installing python version taken from
[avanov.pyenv](https://github.com/avanov/ansible-galaxy-pyenv) role.

## Changes

* [CHANGELOG.md](CHANGELOG.md)

## License

* [MIT](LICENSE)

## Author Information

- [@markosamuli](https://github.com/markosamuli)
