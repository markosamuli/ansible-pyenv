#!/usr/bin/env bash

# Print error into STDERR
error() {
    echo "$@" 1>&2
}

# Get latest release for a GitHub repository
get_latest_release() {
    local repository=$1
    local url="https://api.github.com/repos/${repository}/releases/latest"
    if [ -n "$GITHUB_OAUTH_TOKEN" ]; then
        url="${url}?access_token=${GITHUB_OAUTH_TOKEN}"
    fi
    if test "$(uname)" = "Darwin"; then
        curl --silent "${url}" |
            grep '"tag_name":' |
            sed -E 's/.*"([^"]+)".*/\1/'
    else
        curl --silent "${url}" |
            grep '"tag_name":' |
            sed -r 's/.*"([^"]+)".*/\1/'
    fi
}

# Get latest tag from a GitHub repository
get_latest_tag() {
    local repository=$1
    local url="https://api.github.com/repos/${repository}/tags?per_page=1"
    if [ -n "$GITHUB_OAUTH_TOKEN" ]; then
        url="${url}&access_token=${GITHUB_OAUTH_TOKEN}"
    fi
    if test "$(uname)" = "Darwin"; then
        curl --silent "${url}" |
            grep '"name":' |
            sed -E 's/.*"([^"]+)".*/\1/'
    else
        curl --silent "${url}" |
            grep '"name":' |
            sed -r 's/.*"([^"]+)".*/\1/'
    fi
}

# Update Ansible variable in defaults/main.yml
update_default_variable() {
    local key=$1
    local value=$2
    local file=defaults/main.yml
    update_variable_file "${file}" "${key}" "${value}"
}

# Update Ansible variable in vars/os/ansible_os.yml
update_os_variable() {
    local os=$1
    local key=$2
    local value=$3

    if [ -z "${os}" ]; then
        error "OS name missing"
        exit 1
    fi
    if [ -z "${key}" ]; then
        error "Variable name missing"
        exit 1
    fi
    if [ -z "${value}" ]; then
        error "Variable value missing"
        exit 1
    fi

    local ansible_os
    if [ "${os}" == "darwin" ] || [ "${os}" == "Darwin" ]; then
        ansible_os="Darwin"
    elif [ "${os}" == "debian" ] || [ "${os}" == "Debian" ]; then
        ansible_os="Debian"
    fi
    if [ -z "${ansible_os}" ]; then
        error "Unsupported OS: ${os}"
        exit 1
    fi

    local file="vars/os/${ansible_os}.yml"
    update_variable_file "${file}" "${key}" "${value}"
}

# Update variable in Ansible file
update_variable_file() {
    local file=$1
    local key=$2
    local value=$3
    if [ ! -e "${file}" ]; then
        error "${file} not found"
        exit 1
    fi
    if test "$(uname)" = "Darwin"; then
        sed -i.save -E "s/^($key):.*$/\1: \"${value}\"/" \
            "${file}"
    else
        sed -i.save -r "s/^($key):.*$/\1: \"${value}\"/" \
            "${file}"
    fi
    rm "${file}.save"
}

# Check cURL is installed
check_curl() {
    command -v curl >/dev/null || {
        error "cURL is not installed"
        exit 1
    }
}

# Check jq is installed
check_jq() {
    command -v jq >/dev/null || {
        error "jq not installed"
        exit 1
    }
}
