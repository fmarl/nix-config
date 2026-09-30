#!/usr/bin/env bash
# Partition, format and mount a disk for a NixOS installation into /mnt.

set -Eeuo pipefail

readonly ZFS_POOL="rpool"
readonly LUKS_NAME="cryptroot"
readonly ESP_SIZE="1GiB"
readonly MNT="/mnt"

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly REPO

# Rollback state, set once the corresponding step has started
DISK_TOUCHED=""
LUKS_OPENED=""
POOL_CREATED=""

function usage {
    cat <<EOF
Usage: $(basename "$0") DISK FILESYSTEM HOSTNAME

  DISK        Target disk, e.g. nvme0n1 or /dev/sda. ALL DATA ON IT IS LOST.
  FILESYSTEM  zfs (native encryption), ext4 or xfs (both on LUKS2)
  HOSTNAME    Host to install, should match a directory in hosts/
EOF
}

function err {
    printf '\033[41m%s\033[0m\n' "$*" >&2
}

function info {
    printf '\033[44m%s\033[0m\n' "$*"
}

function die {
    err "$@"
    exit 1
}

# Partition N of $DISK: nvme0n1 -> nvme0n1p1, sda -> sda1
function part {
    if [[ "${DISK}" =~ [0-9]$ ]]; then
        echo "${DISK}p$1"
    else
        echo "${DISK}$1"
    fi
}

function parse_args {
    if [[ "${1-}" == "-h" || "${1-}" == "--help" ]]; then
        usage
        exit 0
    fi

    if [[ $# -ne 3 ]]; then
        usage >&2
        exit 1
    fi

    DISK="$1"
    [[ "${DISK}" == /dev/* ]] || DISK="/dev/${DISK}"
    FS_TYPE="$2"
    HOST="$3"

    case "${FS_TYPE}" in
        zfs | ext4 | xfs) ;;
        *) die "Unsupported filesystem: ${FS_TYPE} (choose zfs, ext4 or xfs)" ;;
    esac

    [[ "${HOST}" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]] || die "Invalid hostname: ${HOST}"

    PART_BOOT="$(part 1)"
    PART_ROOT="$(part 2)"
    readonly DISK FS_TYPE HOST PART_BOOT PART_ROOT
}

function preflight {
    [[ "${EUID}" -eq 0 ]] || die "Must run as root"

    local tools=(parted wipefs mkfs.fat udevadm lsblk blkid mountpoint)
    case "${FS_TYPE}" in
        zfs) tools+=(zpool zfs) ;;
        ext4) tools+=(cryptsetup mkfs.ext4) ;;
        xfs) tools+=(cryptsetup mkfs.xfs) ;;
        *) ;;
    esac

    local tool
    for tool in "${tools[@]}"; do
        command -v "${tool}" >/dev/null || die "Missing tool: ${tool}"
    done

    [[ -b "${DISK}" ]] || die "${DISK} is not a block device"

    local type mounts
    type="$(lsblk -dno TYPE "${DISK}")"
    mounts="$(lsblk -no MOUNTPOINTS "${DISK}")"
    [[ "${type}" == "disk" ]] || die "${DISK} is not a whole disk"
    [[ -z "${mounts//[[:space:]]/}" ]] || die "${DISK} has mounted partitions"
    ! mountpoint -q "${MNT}" || die "${MNT} is already a mountpoint"

    if [[ "${FS_TYPE}" == "zfs" ]] && zpool list "${ZFS_POOL}" >/dev/null 2>&1; then
        die "A pool named ${ZFS_POOL} is already imported"
    fi
    if [[ "${FS_TYPE}" != "zfs" && -e "/dev/mapper/${LUKS_NAME}" ]]; then
        die "/dev/mapper/${LUKS_NAME} is already open"
    fi

    if [[ ! -d "${REPO}/hosts/${HOST}" ]]; then
        err "Warning: ${REPO}/hosts/${HOST} does not exist yet"
    fi
}

function confirm {
    lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,MODEL "${DISK}"
    err "ALL DATA ON ${DISK} WILL BE DESTROYED."

    local answer
    read -rp "Type the disk path (${DISK}) to continue: " answer
    [[ "${answer}" == "${DISK}" ]] || die "Aborted"
}

function partition_disk {
    info "Partitioning ${DISK} (GPT, UEFI) ..."
    DISK_TOUCHED=1

    wipefs -af "${DISK}"
    parted -s "${DISK}" -- \
        mklabel gpt \
        mkpart ESP fat32 1MiB "${ESP_SIZE}" \
        set 1 esp on \
        mkpart root "${ESP_SIZE}" 100%
    udevadm settle

    # A previous install with the same layout leaves its signatures at the same offsets
    wipefs -af "${PART_BOOT}" "${PART_ROOT}"
    mkfs.fat -F 32 -n BOOT "${PART_BOOT}"
}

function mount_boot {
    mkdir -p "${MNT}/boot"
    mount -t vfat -o umask=0077,noexec,nosuid,nodev "${PART_BOOT}" "${MNT}/boot"
}

function setup_zfs {
    info "Setting up encrypted ZFS on ${PART_ROOT} ..."

    # Import by a stable path instead of the kernel name
    local partuuid
    partuuid="$(blkid -s PARTUUID -o value "${PART_ROOT}")"
    [[ -n "${partuuid}" ]] || die "Could not determine PARTUUID of ${PART_ROOT}"

    # Trimming is done periodically by services.zfs.trim
    POOL_CREATED=1
    zpool create -f \
        -o ashift=12 \
        -O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt \
        -O compression=zstd \
        -O acltype=posixacl -O xattr=sa -O dnodesize=auto \
        -O normalization=formD -O relatime=on \
        -O canmount=off -O mountpoint=none \
        "${ZFS_POOL}" "/dev/disk/by-partuuid/${partuuid}"

    info "Creating ZFS datasets ..."
    zfs create -o mountpoint=legacy "${ZFS_POOL}/root"
    zfs create -o mountpoint=legacy "${ZFS_POOL}/nix"
    zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=true "${ZFS_POOL}/home"
    zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=true "${ZFS_POOL}/persist"

    # Keeps the pool usable (e.g. for deleting files) when it runs full
    zfs create -o canmount=off -o mountpoint=none -o refreservation=10G "${ZFS_POOL}/reserved"

    info "Mounting ZFS datasets ..."
    mount -t zfs "${ZFS_POOL}/root" "${MNT}"
    local dataset
    for dataset in nix home persist; do
        mkdir -p "${MNT}/${dataset}"
        mount -t zfs "${ZFS_POOL}/${dataset}" "${MNT}/${dataset}"
    done
    mount_boot
}

function setup_luks {
    info "Setting up LUKS2 on ${PART_ROOT} ..."
    cryptsetup luksFormat --batch-mode --verify-passphrase --type luks2 --label "${LUKS_NAME}" "${PART_ROOT}"

    # --persistent stores the flags in the LUKS2 header, so TRIM also works after boot
    LUKS_OPENED=1
    cryptsetup open --persistent --allow-discards \
        --perf-no_read_workqueue --perf-no_write_workqueue \
        "${PART_ROOT}" "${LUKS_NAME}"
}

function setup_luks_fs {
    setup_luks

    local dev="/dev/mapper/${LUKS_NAME}"
    info "Setting up ${FS_TYPE} on ${dev} ..."
    case "${FS_TYPE}" in
        ext4) mkfs.ext4 -L nixos "${dev}" ;;
        xfs) mkfs.xfs -L nixos "${dev}" ;;
        *) die "Unsupported filesystem: ${FS_TYPE}" ;;
    esac

    mount "${dev}" "${MNT}"
    mount_boot
}

function cleanup {
    local status=$?
    [[ "${status}" -eq 0 ]] && return

    err "Failed with exit code ${status}, rolling back ..."

    if mountpoint -q "${MNT}"; then
        umount -R "${MNT}" || true
    fi
    if [[ -n "${POOL_CREATED}" ]]; then
        zpool destroy -f "${ZFS_POOL}" || true
    fi
    if [[ -n "${LUKS_OPENED}" && -e "/dev/mapper/${LUKS_NAME}" ]]; then
        cryptsetup close "${LUKS_NAME}" || true
    fi
    if [[ -n "${DISK_TOUCHED}" ]]; then
        wipefs -af "${DISK}" >/dev/null || true
    fi
}

function next_steps {
    info "Done. ${DISK} is mounted at ${MNT}. Next steps:"

    local hostid
    hostid="$(head -c4 /dev/urandom | od -An -tx4 | tr -d ' ')"

    cat <<EOF
  1. Hardware config:
       nixos-generate-config --root ${MNT} --show-hardware-config > ${REPO}/hosts/${HOST}/nixos/hardware-configuration.nix
  2. networking.hostId = "${hostid}"; in hosts/${HOST}/nixos/networking.nix
  3. Install:
       nixos-install --flake ${REPO}#${HOST}
  4. Set the user password:
       nixos-enter --root ${MNT} -c 'passwd <user>'
EOF
}

function main {
    parse_args "$@"
    preflight
    confirm

    trap cleanup EXIT
    partition_disk
    case "${FS_TYPE}" in
        zfs) setup_zfs ;;
        *) setup_luks_fs ;;
    esac
    trap - EXIT

    # nixos-install --flake without #host falls back to the hostname
    hostname "${HOST}"
    next_steps
}

main "$@"
