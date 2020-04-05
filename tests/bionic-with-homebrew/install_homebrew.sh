#!/usr/bin/env bash

export CI=true

set -e

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >>~/.profile
