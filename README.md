# markosamuli.pyenv

[![Build Status](https://travis-ci.org/markosamuli/ansible-pyenv.svg?branch=master)](https://travis-ci.org/markosamuli/ansible-pyenv)

Ansible role to install [pyenv](https://github.com/pyenv/pyenv) and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) on Ubuntu or macOS development machines.

## Role Variables

```yaml
# Versions
pyenv_version: "v1.2.8"
pyenv_virtualenv_version: "v1.1.3"

# Initialize shell profile scripts
pyenv_init_shell: yes

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

## License

MIT

## Author Information

- [@markosamuli](https://github.com/markosamuli)
