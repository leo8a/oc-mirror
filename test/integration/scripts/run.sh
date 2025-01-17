#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "$SCRIPT_DIR/common.sh"

# Default to the create and test targets
targets=("${@}")
if [ "${#targets[@]}" -eq 0 ]; then
    targets=(create test)
fi

# Always run the post-run script
trap scripts/post-run.sh EXIT

# Start by looking for anything to recover from a previous step's shared_dir publish
scripts/pre-run.sh

# call your makefile target
make "${targets[@]}" PYTHON=python3.9 ANSIBLE_PLAYBOOK_ARGS="-e oc_bin=/usr/local/bin/oc -e openshift_install_bin=/usr/local/bin/openshift-install"
