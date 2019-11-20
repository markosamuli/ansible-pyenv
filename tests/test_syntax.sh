#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$TESTS_DIR")

# shellcheck source=tests/utils.sh
source "${TESTS_DIR}/utils.sh"

test_syntax() {
    syntax_check || exit 1
}

cd "${PROJECT_ROOT}"

set -e

test_syntax
