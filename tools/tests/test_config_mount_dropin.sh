#!/usr/bin/env bash
# The headless_nm mount-ordering drop-in is installed in-chroot by 30-headless-nm,
# not host-side: CustoPiZer has the root mounted, while the build runner cannot
# mount the image's trixie ext4 (older kernel/e2fsprogs -> bad superblock).

run_tests() {
    local mod seed
    mod="$(cat "${HERE}/../../modules/generic/30-headless-nm")"
    seed="$(cat "${HERE}/../seed-config-partition.sh")"

    # Installed in-chroot, gated on the config-partition fstab entry that the armbian
    # theos-config-partition extension adds (present only on the Dragon image).
    assert_contains "${mod}" "/etc/fstab" "drop-in install is gated on the config-partition fstab entry"
    assert_contains "${mod}" "headless_nm.service.d" "drop-in goes into the headless_nm drop-in dir"
    assert_contains "${mod}" 'Wants=boot-theos\x2dconfig.mount' "drop-in Wants the config-partition mount unit"
    assert_contains "${mod}" 'After=boot-theos\x2dconfig.mount' "drop-in is ordered After the mount unit"

    # The host seed step must not touch the ext4 root anymore.
    assert_not_contains "${seed}" "SEED_MNT_P3" "host seed step no longer mounts the ext4 root"
    assert_not_contains "${seed}" "service.d" "host seed step no longer writes the drop-in"
}
