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
            | map(select(.ref | test("rc") | not))
            | map(.ref)
            | map(capture("refs/tags/v(?<version>.*)"))
            | sort_by(.version) | last | .version'
    # @formatter:on
}

# Get latest stable tag for a GitHub repository
get_latest_python27_version() {
    get_latest_cpython_version "v2.7"
}

# Get latest stable tag for a GitHub repository
get_latest_python37_version() {
    get_latest_cpython_version "v3.7"
}

# Update Ansible variable
update_python2_version() {
    local version=$1
    update_variable "pyenv_python2_version" "$version"
}

# Update Ansible variable
update_python3_version() {
    local version=$1
    update_variable "pyenv_python3_version" "$version"
}

# Update all versions
update_versions() {
    local target=$1
    if [ -z "${target}" ]; then
        error "Target version not defined"
        exit 1
    fi
    if [ "${target}" == "python2" ]; then
        update_python2
    elif [ "${target}" == "python3" ]; then
        update_python3
    else
        error "Unknown target version: ${target}"
        exit 1
    fi
}

# Update Python 2 version
update_python2() {
    local version
    version=$(get_latest_python27_version)
    echo "Latest Python 2.7 release is ${version}"
    update_python2_version "${version}"
}

# Update Python 3 version
update_python3() {
    local version
    version=$(get_latest_python37_version)
    echo "Latest Python 3.7 release is ${version}"
    update_python3_version "${version}"
}

set -e

cd "${PROJECT_ROOT}"

check_curl
check_jq

update_versions "$1"
