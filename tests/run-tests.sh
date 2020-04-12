#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$TESTS_DIR")

ROLE_NAME="$(basename "$PROJECT_ROOT")"
TEST_HOME=/home/test

# Detect Windows Subsystem for Linux
detect_wsl() {
    is_wsl=0
    if [ -e /proc/version ]; then
        if grep -q Microsoft /proc/version; then
            echo "*** Windows Subsystem for Linux detected"
            is_wsl=1
        fi
    fi
}

# Stop all containers
finish() {
    local containers=""
    containers=$(docker ps -q --filter=name="${ROLE_NAME}")
    if [ -n "${containers}" ]; then
        echo "*** Stop all test containers"
        # shellcheck disable=SC2086
        docker stop ${containers}
    fi
}

# Stop container
stop() {
    local image=$1
    local container_name="${ROLE_NAME}-${image}-tests"
    echo "*** Stop container with ${image}"
    docker stop "${container_name}"
}

# Build image
build() {
    local image=$1
    local image_name="${ROLE_NAME}-${image}"
    local base_image
    base_image=$(grep "^FROM" "./tests/${image}/Dockerfile" | sed 's/FROM //')
    echo "*** Pull base image ${base_image}"
    docker pull "${base_image}"
    echo "*** Build image ${image}"
    docker build -t "${image_name}" "./tests/${image}"
}

# Start container in the background
start() {
    local image=$1
    local image_name="${ROLE_NAME}-${image}"
    local container_name="${ROLE_NAME}-${image}-tests"
    echo "*** Start container with image ${image}"
    docker run --rm -it -d \
        -e "TEST_ENV=${image}" \
        -v "${MOUNT_ROOT}:${TEST_HOME}/${ROLE_NAME}" \
        --name "${container_name}" \
        "${image_name}"
}

# Run tests in the container
run_tests() {
    local image=$1
    local test_scripts=(
        "test_syntax.sh"
        "test_install.sh"
    )
    for test_script in "${test_scripts[@]}"; do
        start "${image}"
        run_test_script "${image}" "${test_script}"
        stop "${image}"
        # Give Docker time to clean up
        sleep 1
    done
}

# Run tests in the container
run_tests_with_homebrew() {
    local image=$1
    local test_scripts=(
        "test_syntax.sh"
        "test_install_with_homebrew.sh"
    )
    for test_script in "${test_scripts[@]}"; do
        start "${image}"
        run_test_script "${image}" "${test_script}"
        stop "${image}"
        # Give Docker time to clean up
        sleep 1
    done
}

# Run tests in the container
run_test_script() {
    local image=$1
    local test_script=$2
    local container_name="${ROLE_NAME}-${image}-tests"
    echo "*** Run tests with ${test_script} in ${image}"
    docker exec -it \
        --user test \
        "${container_name}" \
        bash -ilc "${TEST_HOME}/${ROLE_NAME}/tests/${test_script}"
}

trap finish EXIT

detect_wsl

cd "${TESTS_DIR}"

images=("$@")
if [ ${#images[@]} -eq 0 ]; then
    images=(*/Dockerfile)
    images=("${images[@]/\/Dockerfile/}")
fi

cd "$PROJECT_ROOT"

if [ "${is_wsl}" == "1" ]; then
    MOUNT_ROOT="$(pwd -P | sed 's~/mnt/c/~c:/~')"
else
    MOUNT_ROOT="$(pwd -P)"
fi

set -e

for i in "${images[@]}"; do
    build "$i"
done

for i in "${images[@]}"; do
    if [[ $i == *"homebrew"* ]]; then
        run_tests_with_homebrew "$i"
    else
        run_tests "$i"
    fi
done
