#!/bin/bash
# Symlink every file from the shared tutorial directory into inputs/.
# Existing files and links are left untouched, so this is safe to run repeatedly.

SHARED_DIR=${SHARED_DIR:-/data/home/tutorial-DUNENDSim}
INPUTS_DIR="${HOME}/tutorial-DUNENDSim/inputs"

for src in "${SHARED_DIR}"/*; do
    dst="${INPUTS_DIR}/$(basename "${src}")"
    if [ -e "${dst}" ] || [ -L "${dst}" ]; then
        continue
    fi
    ln -s "${src}" "${dst}" && echo "linked ${dst} -> ${src}"
done
