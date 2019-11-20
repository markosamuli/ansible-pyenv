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
    echo "*** Updating ${docker_tag}/Dockerfile"
    mkdir -p "${docker_tag}"
    if test "$(uname)" = "Darwin"; then
        sed -E \
            -e 's!%%FROM%%!'"${docker_image}:${docker_tag}"'!g' \
            -e 's!%%USER%%!'"${TEST_USER}"'!g' \
            -e 's!%%REPOSITORY%%!'"${REPOSITORY}"'!g' \
            -e 's~%%ANSIBLE_VERSION%%~'"${ANSIBLE_VERSION}"'~g' \
            "Dockerfile.template" >"${docker_tag}/Dockerfile"
    else
        sed -r \
            -e 's!%%FROM%%!'"${docker_image}:${docker_tag}"'!g' \
            -e 's!%%USER%%!'"${TEST_USER}"'!g' \
            -e 's!%%REPOSITORY%%!'"${REPOSITORY}"'!g' \
            -e 's~%%ANSIBLE_VERSION%%~'"${ANSIBLE_VERSION}"'~g' \
            "Dockerfile.template" >"${docker_tag}/Dockerfile"
    fi
}

set -euo pipefail

cd "${TESTS_DIR}"

ubuntu_releases=(xenial bionic)
for tag in "${ubuntu_releases[@]}"; do
    update_dockerfile "ubuntu" "${tag}"
done

debian_releases=(stretch buster)
for tag in "${debian_releases[@]}"; do
    update_dockerfile "debian" "${tag}"
done
