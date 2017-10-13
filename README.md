markosamuli.pyenv
=================

[![Build Status](https://travis-ci.org/markosamuli/ansible-pyenv.svg?branch=master)](https://travis-ci.org/markosamuli/ansible-pyenv)

Ansible role to install [pyenv](https://github.com/pyenv/pyenv) and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) on Ubuntu or macOS development machines.

Role Variables
--------------

```yaml
# Versions
pyenv_version: "v1.1.4"
pyenv_virtualenv_version: "v1.1.1"

# Initialize shell profile scripts
pyenv_init_shell: yes

# Define the shell profile scripts to initialiaze
pyenv_shell_profile_scripts:
  - .bashrc
  - .zshrc
```

Example Playbook
----------------

    - hosts: localhost
      connection: local
      roles:
         - { role: markosamuli.pyenv }

License
-------

MIT

Author Information
------------------

- [@markosamuli](https://github.com/markosamuli)
