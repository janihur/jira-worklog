#!/bin/bash

set -o errexit -o nounset -o pipefail

print() {
    echo "$@"
} >> ${filename}

declare -r filename=$(date +'%m-%d')
declare -r today_date=$(date +'%F')

if [[ -f ${filename} ]]; then
    >&2 echo "ERROR: worklog file ${filename} already exists."
    exit 1
fi

print "started: ${today_date} 08:00:00 Europe/Helsinki"

if [[ -d .git ]]; then
    git add ${filename}
fi

vi ${filename}
