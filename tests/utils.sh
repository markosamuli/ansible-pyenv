#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$TESTS_DIR")
export PROJECT_ROOT

# Paths in which Ansible will search for Roles
ANSIBLE_ROLES_PATH=$(dirname "$PROJECT_ROOT")
export ANSIBLE_ROLES_PATH

syntax_check() {
    echo "*** Check syntax"
    if ansible-playbook tests/test.yml -i tests/inventory --syntax-check; then
        echo "Syntax check: pass"
    else
        echo "Syntax check: fail"
        return 1
    fi
}

run_tests() {
    local ansible_vars=("$@")
    local extra_vars
    extra_vars=$(printf ",%s" "${ansible_vars[@]}")
    extra_vars="{${extra_vars:1}}"

    echo "*** Run Ansible playbook"
    if run_playbook "${extra_vars}"; then
        echo "Playbook run: pass"
    else
        echo "Playbook run: fail"
        return 1
    fi

    echo "*** Idempotence test"
    if run_playbook "${extra_vars}" | grep -q 'changed=0.*failed=0'; then
        echo "Idempotence test: pass"
    else
        echo "Idempotence test: fail"
        return 1
    fi
}

run_playbook() {
    local extra_vars="$1"
    ansible-playbook tests/test.yml -i tests/inventory --connection=local \
        -e "${extra_vars}" -v
}
