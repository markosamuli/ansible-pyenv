#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$TESTS_DIR")

TEST_USER="test"
REPOSITORY="$(basename "$PROJECT_ROOT")"
ANSIBLE_VERSION="<2.9.0,!=2.8.6"

# Generate Dockerfile from Dockerfile.template
update_dockerfile() {
    local docker_image=$1
    local docker_tag=$2
    local source="templates/Dockerfile.template"
    local target_dir="${docker_tag}"
    local target_file="${target_dir}/Dockerfile"
    echo "*** Updating ${target_file}"
    mkdir -p "${target_dir}"
    if test "$(uname)" = "Darwin"; then
        sed -E \
            -e 's!%%FROM%%!'"${docker_image}:${docker_tag}"'!g' \
            -e 's!%%USER%%!'"${TEST_USER}"'!g' \
            -e 's!%%REPOSITORY%%!'"${REPOSITORY}"'!g' \
            -e 's~%%ANSIBLE_VERSION%%~'"${ANSIBLE_VERSION}"'~g' \
            "${source}" >"${target_file}"
    else
        sed -r \
            -e 's!%%FROM%%!'"${docker_image}:${docker_tag}"'!g' \
            -e 's!%%USER%%!'"${TEST_USER}"'!g' \
            -e 's!%%REPOSITORY%%!'"${REPOSITORY}"'!g' \
            -e 's~%%ANSIBLE_VERSION%%~'"${ANSIBLE_VERSION}"'~g' \
            "${source}" >"${target_file}"
    fi
}

# Generate Dockerfile from Dockerfile_with_homebrew.template
update_dockerfile_with_homebrew() {
    local docker_image=$1
    local docker_tag=$2
    local source="templates/Dockerfile_with_homebrew.template"
    local target_dir="${docker_tag}-with-homebrew"
    local target_file="${target_dir}/Dockerfile"
    echo "*** Updating ${target_file}"
    mkdir -p "${target_dir}"
    if test "$(uname)" = "Darwin"; then
        sed -E \
            -e 's!%%FROM%%!'"${docker_image}:${docker_tag}"'!g' \
            -e 's!%%USER%%!'"${TEST_USER}"'!g' \
            -e 's!%%REPOSITORY%%!'"${REPOSITORY}"'!g' \
            -e 's~%%ANSIBLE_VERSION%%~'"${ANSIBLE_VERSION}"'~g' \
            "${source}" >"${target_file}"
    else
        sed -r \
            -e 's!%%FROM%%!'"${docker_image}:${docker_tag}"'!g' \
            -e 's!%%USER%%!'"${TEST_USER}"'!g' \
            -e 's!%%REPOSITORY%%!'"${REPOSITORY}"'!g' \
            -e 's~%%ANSIBLE_VERSION%%~'"${ANSIBLE_VERSION}"'~g' \
            "${source}" >"${target_file}"
    fi
    local scripts=(
        "install_homebrew.sh"
    )
    for script in "${scripts[@]}"; do
        cp "templates/${script}" "${target_dir}/${script}"
        chmod u+x "${target_dir}/${script}"
    done
}

set -euo pipefail

cd "${TESTS_DIR}"

ubuntu_releases=(xenial bionic)
for tag in "${ubuntu_releases[@]}"; do
    update_dockerfile "ubuntu" "${tag}"
    update_dockerfile_with_homebrew "ubuntu" "${tag}"
done

debian_releases=(stretch buster)
for tag in "${debian_releases[@]}"; do
    update_dockerfile "debian" "${tag}"
    update_dockerfile_with_homebrew "debian" "${tag}"
done
