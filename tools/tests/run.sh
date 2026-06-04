#!/usr/bin/env bash
# Sources every test_*.sh under this directory and runs its run_tests function.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${HERE}/assert.sh"

rc=0
for t in "${HERE}"/test_*.sh; do
    echo "=== ${t##*/} ==="
    # shellcheck disable=SC1090
    source "${t}"
    run_tests || rc=1
done

finish_tests || rc=1
exit "${rc}"
