#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=tests/utils.sh
source "${TESTS_DIR}/utils.sh"

test_install() {
    local ansible_vars=()
    ansible_vars+=("'pyenv_homebrew_on_linux':true")

    run_tests "${ansible_vars[@]}" || exit 1
}

check_brew() {
    if ! command -v brew >/dev/null; then
        echo "brew not found"
        exit 1
    fi
    brew --version
}

cd "${PROJECT_ROOT}" || {
    echo "${PROJECT_ROOT} not found"
    exit 1
}

# Check Homebrew is on the PATH
check_brew

# Install
test_install
