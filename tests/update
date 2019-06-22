#!/bin/bash

set -euo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

user="test"
repository="$(basename $(dirname $(pwd)))"
ansible_version="<2.9.0"

image="ubuntu"
ubuntu_releases=(xenial bionic)
for tag in "${ubuntu_releases[@]}"; do
    dir="${tag}"
    echo "*** Updating $dir/Dockerfile"
    sed -r \
        -e 's!%%FROM%%!'"$image:$tag"'!g' \
        -e 's!%%USER%%!'"$user"'!g' \
        -e 's!%%REPOSITORY%%!'"$repository"'!g' \
        -e 's!%%ANSIBLE_VERSION%%!'"$ansible_version"'!g' \
        "Dockerfile.template" > "$dir/Dockerfile"
done

image="debian"
debian_releases=(stretch buster)
for tag in "${debian_releases[@]}"; do
    dir="${tag}"
    echo "*** Updating $dir/Dockerfile"
    sed -r \
        -e 's!%%FROM%%!'"$image:$tag"'!g' \
        -e 's!%%USER%%!'"$user"'!g' \
        -e 's!%%REPOSITORY%%!'"$repository"'!g' \
        -e 's!%%ANSIBLE_VERSION%%!'"$ansible_version"'!g' \
        "Dockerfile.template" > "$dir/Dockerfile"
done
