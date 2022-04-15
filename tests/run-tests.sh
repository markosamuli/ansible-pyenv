#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$TESTS_DIR")

ROLE_NAME="$(basename "$PROJECT_ROOT")"
TEST_HOME=/home/test

if [[ $(uname -m) == arm64 ]]; then
    USE_BUILDKIT=${USE_BUILDKIT:-true}
else
    USE_BUILDKIT=${USE_BUILDKIT:-false}
fi

IMAGES_DIR="images"

docker_run_opts=()

debug="false"
test_with_git="true"
test_with_homebrew="true"

error() {
    echo "$@" 1>&2
}

detect_wsl() {
    is_wsl=0
    if [[ -d "/run/WSL" ]]; then
        echo "*** Windows Subsystem for Linux (WSL2) detected"
        is_wsl=1
        wsl_version='WSL2'
        return
    fi
    if [ ! -e /proc/version ]; then
        return
    fi
    if grep -q Microsoft /proc/version; then
        echo "*** Windows Subsystem for Linux (WSL1) detected"
        is_wsl=1
        wsl_version='WSL1'
        return
    fi
}

setup_mount_root() {
    if [ "${is_wsl}" == "1" ] && [ "${wsl_version}" == "WSL1" ]; then
        MOUNT_ROOT="$(pwd -P | sed 's~/mnt/c/~c:/~')"
    else
        MOUNT_ROOT="$(pwd -P)"
    fi
}

setup_docker_opts() {
    if [ -z "$CI" ]; then
        docker_run_opts+=("-it")
    fi
}

finish() {
    local containers=""
    containers=$(docker ps -q --filter=name="${ROLE_NAME}")
    if [ -n "${containers}" ]; then
        echo "*** Stop all test containers"
        # shellcheck disable=SC2086
        docker stop ${containers}
    fi
}

stop() {
    local image=$1
    local container_name="${ROLE_NAME}-${image}-tests"
    echo "*** Stop container with ${image}"
    docker stop "${container_name}"
}

build() {
    local image=$1
    local image_name="${ROLE_NAME}-${image}"
    local image_dir="${TESTS_DIR}/${IMAGES_DIR}/${image}"
    local dockerfile="${image_dir}/Dockerfile"
    local base_image
    base_image=$(grep "^FROM" "${dockerfile}" | sed 's/FROM //')
    echo "*** Pull base image ${base_image}"
    docker pull "${base_image}"
    echo "*** Build image ${image}"
    docker build -t "${image_name}" "${image_dir}"
}

build_using_buildkit() {
    local image=$1
    local platform=$2
    local image_name="${ROLE_NAME}-${image}"
    local image_dir="${TESTS_DIR}/${IMAGES_DIR}/${image}"
    local dockerfile="${image_dir}/Dockerfile"
    echo "*** Build image ${image}"
    docker buildx build --platform "${platform}" -t "${image_name}" "${image_dir}"
}

start() {
    local image=$1
    local platform=$2
    local image_name="${ROLE_NAME}-${image}"
    local container_name="${ROLE_NAME}-${image}-tests"
    local start_opts=()
    if [ -n "${platform}" ]; then
        start_opts+=("--platform")
        start_opts+=("${platform}")
    fi
    echo "*** Start container with image ${image}"
    docker run --rm -d \
        "${docker_run_opts[@]}" \
        "${start_opts[@]}" \
        -e "TEST_ENV=${image}" \
        -v "${MOUNT_ROOT}:${TEST_HOME}/${ROLE_NAME}" \
        --name "${container_name}" \
        "${image_name}" || {
        error "failed to start container"
        exit 1
    }
}

run_tests() {
    local image=$1
    local platform=$2
    if [[ $image == *"homebrew"* ]]; then
        if [ "${test_with_homebrew}" == "true" ]; then
            run_tests_with_homebrew "$image" "$platform" || {
                error "failed Homebrew installation in ${image}"
                return 1
            }
        fi
    else
        if [ "${test_with_git}" == "true" ]; then
            run_tests_with_git "$image" "$platform" || {
                error "failed Git installation in ${image}"
                return 1
            }
        fi
    fi
}

run_tests_with_git() {
    local image=$1
    local platform=$2
    local test_scripts=(
        "test_syntax.sh"
        "test_install.sh"
    )
    local failed=0
    echo "*** Run tests installing with Git install"
    for test_script in "${test_scripts[@]}"; do
        start "${image}" "${platform}"
        run_test_script "${image}" "${test_script}" || failed=1
        stop "${image}"
        # Give Docker time to clean up
        sleep 1
    done
    if [ "${failed}" -gt "0" ]; then
        return "${failed}"
    fi
}

run_tests_with_homebrew() {
    local image=$1
    local platform=$2
    local test_scripts=(
        "test_syntax.sh"
        "test_install_with_homebrew.sh"
    )
    local failed=0
    echo "*** Run tests installing with Homebrew install"
    for test_script in "${test_scripts[@]}"; do
        start "${image}" "${platform}"
        run_test_script "${image}" "${test_script}" || failed=1
        stop "${image}"
        # Give Docker time to clean up
        sleep 1
    done
    if [ "${failed}" -gt "0" ]; then
        return "${failed}"
    fi
}

run_test_script() {
    local image=$1
    local test_script=$2
    local container_name="${ROLE_NAME}-${image}-tests"
    echo "*** Run tests with ${test_script} in ${image}"
    docker exec \
        "${docker_run_opts[@]}" \
        --user test \
        "${container_name}" \
        bash -ilc "${TEST_HOME}/${ROLE_NAME}/tests/${test_script}" || {
        error "${test_script} on ${image} failed"
        return 1
    }
}

debug_image() {
    local image=$1
    local container_name="${ROLE_NAME}-${image}-tests"
    start "${image}"
    docker exec \
        "${docker_run_opts[@]}" \
        --user test \
        "${container_name}" \
        bash -il
}

if ! command -v docker >/dev/null; then
    error "docker not found"
    exit 1
fi

# Parse command line arguments
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --debug)
            debug="true"
            shift
            ;;
        --with-git)
            test_with_git="true"
            shift
            ;;
        --without-git)
            test_with_git="false"
            shift
            ;;
        --with-homebrew)
            test_with_homebrew="true"
            shift
            ;;
        --without-homebrew)
            test_with_homebrew="false"
            shift
            ;;
        *)                     # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift              # past argument
            ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

trap finish EXIT

detect_wsl

setup_docker_opts

cd "${TESTS_DIR}"

images=("$@")
if [ ${#images[@]} -eq 0 ]; then
    images=(images/*/Dockerfile)
fi
images=("${images[@]/${PROJECT_ROOT}\//}")
images=("${images[@]/tests\//}")
images=("${images[@]/images\//}")
images=("${images[@]/\/Dockerfile/}")

platforms=(
    "linux/amd64"
)

cd "${PROJECT_ROOT}"

setup_mount_root

set -e

for i in "${images[@]}"; do
    if [ "${USE_BUILDKIT}" == "true" ]; then
        for p in "${platforms[@]}"; do
            build_using_buildkit "$i" "$p" || {
                error "failed to build $i for platform $p"
                exit 1
            }
        done
    else
        build "$i" || {
            error "failed to build $i"
            exit 1
        }
    fi
done

if [ "${debug}" == "true" ]; then
    if [ ${#images[@]} -gt 1 ]; then
        error "limit to one Docker image to debug"
        exit 1
    fi
    debug_image "${images[0]}"
else
    for i in "${images[@]}"; do
        if [ "${USE_BUILDKIT}" == "true" ]; then
            for p in "${platforms[@]}"; do
                run_tests "$i" "$p" || {
                    error "failed tests $i on platform $p"
                    exit 1
                }
            done
        else
            run_tests "$i" || {
                error "failed tests in $i"
                exit 1
            }
        fi
    done
fi
