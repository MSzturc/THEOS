#!/usr/bin/env bash
# Tests headless_nm's deterministic handoff-file lookup against a fake /boot tree.

run_tests() {
    local script="${HERE}/../../modules/generic/files/headless-nm/headless_nm"

    # headless_nm guards main behind the BASH_SOURCE check, so sourcing only defines
    # functions + globals. It sets `set -euo pipefail`; relax it so the runner's
    # assertion command-substitutions cannot trip the runner's own shell.
    # shellcheck disable=SC1090
    source "${script}"
    set +eu

    # No RETURN trap here: a RETURN trap fires when find_setup_file (a function)
    # returns, which would delete the tree mid-test. Clean up explicitly at the end.
    local tmp; tmp="$(mktemp -d)"
    mkdir -p "${tmp}/boot/theos-config"

    # Case 1: explicit config-partition file wins over a stale /boot file.
    echo "x" > "${tmp}/boot/headless_nm.txt"
    echo "y" > "${tmp}/boot/theos-config/headless_nm.txt"
    assert_equals "${tmp}/boot/theos-config/headless_nm.txt" \
        "$(find_setup_file "${tmp}/boot")" "explicit config path wins"

    # Case 2: only a find-reachable file -> exactly that one path.
    rm -f "${tmp}/boot/theos-config/headless_nm.txt"
    assert_equals "${tmp}/boot/headless_nm.txt" \
        "$(find_setup_file "${tmp}/boot")" "single find result returned"

    # Case 3: nothing present -> empty.
    rm -f "${tmp}/boot/headless_nm.txt"
    assert_equals "" "$(find_setup_file "${tmp}/boot")" "no file -> empty"

    rm -rf "${tmp}"
}
