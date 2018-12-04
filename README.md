# markosamuli.pyenv

[![Build Status](https://travis-ci.org/markosamuli/ansible-pyenv.svg?branch=master)](https://travis-ci.org/markosamuli/ansible-pyenv)

Ansible role to install [pyenv](https://github.com/pyenv/pyenv) and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) on Ubuntu or macOS development machines.

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
pyenv_version: "v1.2.8"
pyenv_virtualenv_version: "v1.1.3"

# Initialize shell profile scripts
pyenv_init_shell: yes

# Python versions to install
pyenv_python_versions:
  - "2.7.15"
  - "3.7.1"

# Set global pyenv version
pyenv_global: "3.7.1"

# Define the shell profile scripts to initialiaze
pyenv_shell_profile_scripts:
  - .bashrc
  - .zshrc
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

## License

MIT

## Author Information

- [@markosamuli](https://github.com/markosamuli)
