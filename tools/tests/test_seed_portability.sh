#!/usr/bin/env bash
# Guards seed-config-partition.sh against the two defects that made it die silently
# on the CI runner: a non-portable lsblk column and the lack of failure diagnostics.

run_tests() {
    local script src
    script="${HERE}/../seed-config-partition.sh"
    src="$(cat "${script}")"

    # The build runner (ubuntu-22.04) ships util-linux 2.37; lsblk's PARTN column
    # only exists from 2.38 on. Combined with pipefail+set -e+2>/dev/null it aborted
    # the script with exit 1 and no message. The p2 node is partition 2 by address.
    assert_not_contains "${src}" "PARTN" "no util-linux 2.38 lsblk column (runner is 2.37)"

    # errtrace + an ERR trap turn any unguarded failure into a located message
    # instead of a silent exit 1.
    assert_contains "${src}" "set -Eeuo pipefail" "errtrace on so the ERR trap fires inside functions"
    assert_contains "${src}" "' ERR" "a trap is wired to ERR so an abort prints where it died"
}
