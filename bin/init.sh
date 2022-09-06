#!/bin/bash

set -x

l_has() {
  type "${1-}" >/dev/null 2>&1
}

SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

TARGET="${1:-$SCRIPT_DIR/..}"

# deactivate any venv if loaded
if l_has "deactivate"; then
deactivate
fi

if [ -d ${TARGET}/venv ]; then
rm -rf ${TARGET}/venv
fi

python3 -m venv ${TARGET}/venv
source ${TARGET}/venv/bin/activate
pip install --upgrade pip
pip install -r ${TARGET}/requirements.txt

