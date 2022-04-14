#!/usr/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$SCRIPTS_DIR")

# shellcheck source=scripts/utils.sh
source "${SCRIPTS_DIR}/utils.sh"

# Get latest stable tag for a GitHub repository
get_latest_cpython_version() {
    local target_version=$1
    local repository=python/cpython
    local url="https://api.github.com/repos/${repository}/git/refs/tags"
    if [ -n "$GITHUB_OAUTH_TOKEN" ]; then
        url="${url}?access_token=${GITHUB_OAUTH_TOKEN}"
    fi
    # @formatter:off
    curl --silent "${url}" |
        jq --arg version_tag "${target_version}" \
            -r 'map(select(.object.type == "tag"))
            | map(select(.ref | test("refs/tags/" + $version_tag)))
            | map(select(.ref | test("rc|0[ab][0-9]") | not))
            | map(.ref)
            | map(capture("refs/tags/v(?<version>.*)"))
            | sort_by(.version | split(".") | map(tonumber))
            | last | .version'
    # @formatter:on
}

update_versions() {
    local target=$1
    if [ -z "${target}" ]; then
        error "Target version not defined"
        exit 1
    fi
    if [ "${target}" == "python2" ]; then
        error "Python 2.7 is no longer supported"
        exit 1
    elif [ "${target}" == "python3" ]; then
        error "Use python37, python38 or python310 as the target version"
        exit 1
    elif [ "${target}" == "python37" ]; then
        update_python "python37" "3.7"
    elif [ "${target}" == "python38" ]; then
        update_python "python38" "3.8"
    elif [ "${target}" == "python39" ]; then
        update_python "python39" "3.9"
    elif [ "${target}" == "python310" ]; then
        update_python "python310" "3.10"
    else
        error "Unknown target version: ${target}"
        exit 1
    fi
}

update_python() {
    local target=$1
    local target_version=$2
    local latest_version
    latest_version=$(get_latest_cpython_version "v${target_version}")
    echo "Latest Python ${target_version} release is ${latest_version}"
    update_default_variable "pyenv_${target}_version" "${latest_version}"
}

set -e

cd "${PROJECT_ROOT}"

check_curl
check_jq

update_versions "$1"
