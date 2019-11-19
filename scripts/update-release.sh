#!/usr/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$SCRIPTS_DIR")

# shellcheck source=scripts/utils.sh
source "${SCRIPTS_DIR}/utils.sh"

# Update pyenv version
update_pyenv_version() {
    local version=$1
    update_default_variable "pyenv_version" "${version}"
}

# Update pyenv-virtualenv version
update_pyenv_virtualenv_version() {
    local version=$1
    update_default_variable "pyenv_virtualenv_version" "${version}"
}

# Get latest pyenv version
latest_pyenv_version() {
    local latest_release=""
    local errmsg="Failed to get latest pyenv/pyenv release"
    latest_release=$(get_latest_release pyenv/pyenv)
    if [ -z "${latest_release}" ]; then
        error "${errmsg}"
        exit 1
    fi
    echo "${latest_release}"
}

# Get latest pyenv-virtualenv version
latest_pyenv_virtualenv_version() {
    local latest_release=""
    local errmsg="Failed to get latest pyenv/pyenv-virtualenv release"
    latest_release=$(get_latest_release pyenv/pyenv-virtualenv)
    if [ -z "${latest_release}" ]; then
        error "${errmsg}"
        exit 1
    fi
    echo "${latest_release}"
}

# Update all versions
update_versions() {
    local repository=$1
    local version
    if [ -z "${repository}" ]; then
        error "Repository not defined"
        exit 1
    fi
    if [ "${repository}" == "pyenv" ]; then
        version=$(latest_pyenv_version)
        echo "Latest pyenv release is ${version}"
        update_pyenv_version "${version}"
    elif [ "${repository}" == "pyenv-virtualenv" ]; then
        version=$(latest_pyenv_virtualenv_version)
        echo "Latest pyenv-virtualenv release is ${version}"
        update_pyenv_virtualenv_version "${version}"
    else
        error "Unknown repository: ${repository}"
        exit 1
    fi
}

set -e

cd "${PROJECT_ROOT}"

check_curl
update_versions "$1"
