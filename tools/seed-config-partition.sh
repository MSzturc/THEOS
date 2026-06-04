#!/usr/bin/env bash
# Seed the THEOS Windows config partition (p2, label THEOS) on a built image with
# the WiFi handoff template + README. Host-side; needs root for loop mounts.
# Sourcing with SEED_LIB_ONLY=1 defines the functions without acting.
set -Eeuo pipefail

# Cleanup state — populated by seed_image, released by the script-level EXIT trap
# so loop devices/mounts are freed even on early failure or signal.
SEED_LOOP=""; SEED_MNT_P2=""
seed_cleanup() {
    [[ -n "${SEED_MNT_P2}" ]] && mountpoint -q "${SEED_MNT_P2}" && umount "${SEED_MNT_P2}" || true
    [[ -n "${SEED_LOOP}" ]] && losetup -d "${SEED_LOOP}" 2>/dev/null || true
    [[ -n "${SEED_MNT_P2}" ]] && rmdir "${SEED_MNT_P2}" 2>/dev/null || true
}

# seed_image <image.img> <files-dir> <os-name>
# files-dir holds headless_nm.txt.template and WiFi-README.txt.
seed_image() {
    local img="$1" files_dir="$2" os_name="$3"

    SEED_LOOP="$(losetup --show --find --partscan "${img}")"
    SEED_MNT_P2="$(mktemp -d)"

    # Wait for both partition nodes (partscan is not always instant; p3 may lag p2).
    local i
    for i in 1 2 3 4 5 6 7 8 9 10; do
        [[ -b "${SEED_LOOP}p2" && -b "${SEED_LOOP}p3" ]] && break
        sleep 1
    done
    [[ -b "${SEED_LOOP}p2" ]] || { echo "ERROR: ${SEED_LOOP}p2 never appeared" >&2; return 1; }
    [[ -b "${SEED_LOOP}p3" ]] || { echo "ERROR: ${SEED_LOOP}p3 never appeared" >&2; return 1; }

    # p2 must still be the ~128 MiB THEOS vfat partition — proves CustoPiZer grew p3, not p2.
    local fstype label size_mib p3_fs
    fstype="$(blkid -s TYPE -o value "${SEED_LOOP}p2" || true)"
    label="$(blkid -s LABEL -o value "${SEED_LOOP}p2" || true)"
    size_mib=$(( $(blockdev --getsize64 "${SEED_LOOP}p2") / 1048576 ))
    if [[ "${fstype}" != "vfat" || "${label}" != "THEOS" ]]; then
        echo "ERROR: ${SEED_LOOP}p2 is not the THEOS config partition (FSTYPE=${fstype} LABEL=${label})" >&2
        return 1
    fi
    if [[ "${size_mib}" -lt 120 || "${size_mib}" -gt 136 ]]; then
        echo "ERROR: ${SEED_LOOP}p2 is ${size_mib}MiB, expected ~128 (root resize hit the wrong partition?)" >&2
        return 1
    fi
    p3_fs="$(blkid -s TYPE -o value "${SEED_LOOP}p3" || true)"
    [[ "${p3_fs}" == "ext4" ]] || { echo "ERROR: ${SEED_LOOP}p3 is '${p3_fs}', expected ext4 root" >&2; return 1; }

    # Seed p2 (FAT); the root-fs mount-ordering drop-in is installed in-chroot by 30-headless-nm.
    mount "${SEED_LOOP}p2" "${SEED_MNT_P2}"
    cp "${files_dir}/headless_nm.txt.template" "${SEED_MNT_P2}/headless_nm.txt.template"
    sed "s|OS_NAME|${os_name}|g" "${files_dir}/WiFi-README.txt" > "${SEED_MNT_P2}/WiFi-README.txt"
    sync
    umount "${SEED_MNT_P2}"
}

if [[ "${SEED_LIB_ONLY:-0}" != "1" && "${BASH_SOURCE[0]}" == "${0}" ]]; then
    trap 'rc=$?; echo "ERROR: seed-config-partition.sh aborted at line ${LINENO} (exit ${rc})" >&2' ERR
    trap seed_cleanup EXIT
    # Args: <image.img> <files-dir> <os-name>
    seed_image "$1" "$2" "$3"
fi
