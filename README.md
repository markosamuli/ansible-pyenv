# markosamuli.pyenv

[![Ansible Quality Score](https://img.shields.io/ansible/quality/38342.svg)](https://galaxy.ansible.com/markosamuli/pyenv)
[![Ansible Role](https://img.shields.io/ansible/role/38342.svg)](https://galaxy.ansible.com/markosamuli/pyenv)
[![GitHub release](https://img.shields.io/github/release/markosamuli/ansible-pyenv.svg)](https://github.com/markosamuli/ansible-pyenv/releases)
[![License](https://img.shields.io/github/license/markosamuli/ansible-pyenv.svg)](https://github.com/markosamuli/ansible-pyenv/blob/master/LICENSE)

| Branch  | Status |
|---------|--------|
| master  | [![Build Status](https://travis-ci.org/markosamuli/ansible-pyenv.svg?branch=master)](https://travis-ci.org/markosamuli/ansible-pyenv)
| develop | [![Build Status](https://travis-ci.org/markosamuli/ansible-pyenv.svg?branch=develop)](https://travis-ci.org/markosamuli/ansible-pyenv)

Ansible role to install [pyenv] and [pyenv-virtualenv] on Ubuntu or macOS
development machines.

Optionally, [pyenv-virtualenvwrapper] can be installed and used for managing
environments.

Don't use this role on production servers as it supports installing pyenv only
under user home directory.

[pyenv]: https://github.com/pyenv/pyenv
[pyenv-virtualenv]: https://github.com/pyenv/pyenv-virtualenv
[pyenv-virtualenvwrapper]: https://github.com/pyenv/pyenv-virtualenvwrapper

## macOS Mojave

This role installs macOS SDK headers from
`/Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg`
if they're not found in `/usr/include`.

## Installed Python versions

This role installs [Python] versions defined in `pyenv_python_versions` variable.

To set global version, set `pyenv_global` variable to the desired version. By
default this is not configured.

[Python]: https://www.python.org

## Changes to shell config files

This role creates config file in `~/.pyenv/.pyenvrc` that is loaded in
`.bashrc` and `.zshrc` files.

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
  - "2.7.16"
  - "3.7.3"

# Set global pyenv version
pyenv_global: "3.7.3"

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

Update default [Python] 2.7 version:

```bash
./update-python python2
```

Update default [Python] 3.7 version:

```bash
./update-python python3
```

## Acknowledgments

Use of `.pyenvrc` file and parts used for installing python version taken from
[avanov.pyenv](https://github.com/avanov/ansible-galaxy-pyenv) role.

## Changes

* [CHANGELOG.md](CHANGELOG.md)

## License

* [MIT](LICENSE)

## Author Information

* [@markosamuli](https://github.com/markosamuli)
