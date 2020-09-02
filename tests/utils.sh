#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$TESTS_DIR")
export PROJECT_ROOT

# Paths in which Ansible will search for Roles
ANSIBLE_ROLES_PATH=$(dirname "$PROJECT_ROOT")
export ANSIBLE_ROLES_PATH

msg() {
    local message="$*"
    if [ -n "${TEST_ENV}" ]; then
        message="[${TEST_ENV}] ${message}"
    fi
    echo "${message}"
}

syntax_check() {
    echo "*** Check syntax"
    if ansible-playbook tests/test.yml -i tests/inventory --syntax-check; then
        msg "Syntax check: pass"
    else
        msg "Syntax check: fail"
        return 1
    fi
}

run_tests() {
    local ansible_vars=("$@")
    local extra_vars
    extra_vars=$(printf ",%s" "${ansible_vars[@]}")
    extra_vars="{${extra_vars:1}}"

    msg "*** Run Ansible playbook"
    if run_playbook "${extra_vars}"; then
        msg "Playbook run: pass"
    else
        msg "Playbook run: fail"
        return 1
    fi

    msg "*** Idempotence test"
    if run_playbook "${extra_vars}" | grep -q 'changed=0.*failed=0'; then
        msg "Idempotence test: pass"
    else
        msg "Idempotence test: fail"
        return 1
    fi
}

run_playbook() {
    local extra_vars="$1"
    ansible-playbook tests/test.yml -i tests/inventory --connection=local \
        -e "${extra_vars}" -v
}
