#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=tests/utils.sh
source "${TESTS_DIR}/utils.sh"

test_install() {
    local ansible_vars=()
    ansible_vars+=("'pyenv_virtualenvwrapper':true")

    run_tests "${ansible_vars[@]}" || exit 1
}

cd "${PROJECT_ROOT}"

set -e

# Install with pyenv-virtualenvwrapper
test_install
