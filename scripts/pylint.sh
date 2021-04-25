#!/usr/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$SCRIPTS_DIR")

VENV="${PROJECT_ROOT}/venv"

if [ -d "${VENV}" ]; then
    "${VENV}/bin/pylint" "$*"
else
    python -m pylint "$*"
fi
