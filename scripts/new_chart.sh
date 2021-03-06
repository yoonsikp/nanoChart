#!/usr/bin/env bash
# stop on all errors
set -euf -o pipefail
set -x

AUTHOR="${NCHART_NAME} <${NCHART_ACCOUNT}@${NCHART_ORG}>"

# convert to lowercase, remove dashes
NEWUUID="$(uuidgen | tr '[:upper:]' '[:lower:]'  | sed 's/-//g')"

mkdir -p "${NCHART_GOLDEN}/${NEWUUID:0:2}"
CHARTDIR="${NCHART_GOLDEN}/${NEWUUID:0:2}/${NEWUUID:2:32}.git/"

# crash if chart directory already exists
mkdir "${CHARTDIR}"

# initialize chart with git template
git init --quiet --initial-branch main --bare \
  --template=./templates/golden/git "${CHARTDIR}"

# enforce file integrity
git -C "${CHARTDIR}" config transfer.fsckObjects true

# prevent deleting main branch
git -C "${CHARTDIR}" config receive.denyDeletes true

# stop non fast forward push
git -C "${CHARTDIR}" config receive.denyNonFastForwards true

echo "Your new chart is located: ${CHARTDIR}.git"
