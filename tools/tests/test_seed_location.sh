#!/usr/bin/env bash
# Guards that no host-side helper lands in the directory CustoPiZer runs in-chroot.
# CustoPiZer executes every top-level file in its scripts dir inside the chroot with
# no arguments; a host-only script there (loop mounts, set -u, positional args)
# crashes the build. seed-config-partition.sh must live outside scripts/, in tools/.

run_tests() {
    local repo_root scripts_dir
    repo_root="$(cd "${HERE}/../.." && pwd)"
    scripts_dir="${repo_root}/scripts"

    local stray
    stray="$(find "${scripts_dir}" -maxdepth 1 -type f -name '*.sh' -printf '%f\n' 2>/dev/null | sort | tr '\n' ' ')"
    assert_equals "" "${stray}" "CustoPiZer scripts dir has no top-level shell scripts"

    [[ -f "${repo_root}/tools/seed-config-partition.sh" ]] && local found=yes || local found=no
    assert_equals "yes" "${found}" "host-side seed helper lives under tools/"
}
