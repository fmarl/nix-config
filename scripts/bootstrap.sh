#!/usr/bin/env bash

set -euo pipefail

export COLOR_RESET="\033[0m"
export RED_BG="\033[41m"
export BLUE_BG="\033[44m"

if [ -z "${1-}" ]; then
    echo "Disk isn't specified"
    exit 1
fi

if [ -z "${2-}" ]; then
    echo "Filesystem isn't specified. Choose between xfs, ext4, and zfs"
    exit 1
fi

if [ -z "${3-}" ]; then
    echo "Hostname isn't specified"
    exit 1
fi

export DISK=$1
export DISK_PATH="/dev/${DISK}"
export FS_TYPE=$2
export HOSTNAME=$3

if [[ ! -b "$DISK_PATH" ]]; then
    err "Invalid disk: ${DISK_PATH} does not exist or is not a valid block device."
    exit 1
fi

if [[ "$DISK_PATH" == *"nvme"* ]]; then
    export PART_BOOT="${DISK_PATH}p1"
    export PART_ROOT="${DISK_PATH}p2"
else
    export PART_BOOT="${DISK_PATH}1"
    export PART_ROOT="${DISK_PATH}2"
fi

function err {
    echo -e "${RED_BG}$1${COLOR_RESET}"
}

function info {
    echo -e "${BLUE_BG}$1${COLOR_RESET}"
}

function check_root {
    if [[ "$EUID" -ne 0 ]]; then
        err "Must run as root"
        exit 1
    fi
}

function partition_disk {
    info "Partitioning disk ${DISK_PATH} for UEFI (GPT) ..."
    parted "$DISK_PATH" -- mklabel gpt
    parted "$DISK_PATH" -- mkpart ESP fat32 1MiB 512MiB
    parted "$DISK_PATH" -- mkpart primary 512MiB 100%
    parted "$DISK_PATH" -- set 1 boot on
    mkfs.fat -F 32 -n boot "${PART_BOOT}"
}

function setup_filesystem {
    case "$FS_TYPE" in
        zfs) setup_zfs ;;
        ext4) setup_ext4 ;;
        xfs) setup_xfs ;;
        *)
            err "Unsupported filesystem type: ${FS_TYPE}"
            exit 1
            ;;
    esac
}

function setup_zfs {
    info "Setting up ZFS on ${PART_ROOT} ..."
    export ZFS_POOL="rpool"
    zpool create -o ashift=12 -O compression=lz4 -O acltype=posixacl -O xattr=sa -O relatime=on -o autotrim=on -f "$ZFS_POOL" "$PART_ROOT"

    info "Creating ZFS datasets ..."
    zfs create -p -o mountpoint=legacy "$ZFS_POOL/root"
    zfs create -p -o mountpoint=legacy "$ZFS_POOL/nix"
    zfs create -p -o mountpoint=legacy "$ZFS_POOL/home"
    zfs create -p -o mountpoint=legacy "$ZFS_POOL/persist"

    info "Mounting ZFS datasets ..."
    mount -t zfs "$ZFS_POOL/root" /mnt
    mkdir -p /mnt/{boot,nix,home,persist}
    mount -t vfat -o noexec,nosuid "$PART_BOOT" /mnt/boot
    mount -t zfs "$ZFS_POOL/nix" /mnt/nix
    mount -t zfs "$ZFS_POOL/home" /mnt/home
    mount -t zfs "$ZFS_POOL/persist" /mnt/persist
}

function setup_luks {
    info "Setting up LUKS encryption on ${PART_ROOT} ..."
    cryptsetup luksFormat --type luks2 "$PART_ROOT"
    cryptsetup open "$PART_ROOT" cryptroot
}

function setup_ext4 {
    setup_luks

    info "Setting up ext4 on the encrypted volume ..."
    mkfs.ext4 -L nixos_root /dev/mapper/cryptroot

    info "Mounting encrypted ext4 filesystem ..."
    mount /dev/mapper/cryptroot /mnt
    mkdir -p /mnt/boot
    mount -o noexec,nosuid "$PART_BOOT" /mnt/boot
}

function setup_xfs {
    setup_luks

    info "Setting up xfs on the encrypted volume ..."
    mkfs.xfs -L nix /dev/mapper/cryptroot

    info "Mounting encrypted xfs filesystem ..."
    mount /dev/mapper/cryptroot /mnt
    mkdir -p /mnt/boot
    mount -o noexec,nosuid "$PART_BOOT" /mnt/boot
}

function generate_nixos_config {
    info "Generating NixOS configuration ..."
    nixos-generate-config --root /mnt

    # Prompt for root and user passwords
    info "Enter password for the root user ..."
    ROOT_PASSWORD_HASH="$(mkpasswd -m sha-512 | sed 's/\$/\\$/g')"

    info "Enter personal user name ..."
    read USER_NAME

    info "Enter password for user '${USER_NAME}' ..."
    USER_PASSWORD_HASH="$(mkpasswd -m sha-512 | sed 's/\$/\\$/g')"

    # Create configuration.nix
    info "Writing NixOS configuration ..."
    cat <<EOF > /mnt/etc/nixos/configuration.nix
{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostId = "$(head -c 8 /etc/machine-id)";
  networking.useDHCP = true;

  networking.hostName = "${HOSTNAME}";
  environment.systemPackages = with pkgs; [ vim htop git ];

  users.mutableUsers = false;
  users.users = {
    root = { initialHashedPassword = "${ROOT_PASSWORD_HASH}"; };
    ${USER_NAME} = {
      isNormalUser = true;
      initialHashedPassword = "${USER_PASSWORD_HASH}";
      extraGroups = [ "wheel" ];
    };
  };

  system.stateVersion = "23.11";
}
EOF
    chmod 600 /mnt/etc/nixos/configuration.nix
}

# Install NixOS
function install_nixos {
    info "Installing NixOS ..."
    nixos-install --no-root-passwd
}

# Cleanup function to rollback changes in case of failure
function cleanup {
    err "An error occurred, performing cleanup..."

    # Unmount all mounted partitions
    info "Unmounting filesystems..."
    if mountpoint -q /mnt/boot; then umount /mnt/boot; fi
    if mountpoint -q /mnt/nix; then umount /mnt/nix; fi
    if mountpoint -q /mnt/home; then umount /mnt/home; fi
    if mountpoint -q /mnt/persist; then umount /mnt/persist; fi
    if mountpoint -q /mnt; then umount /mnt; fi

    # If ZFS is used, destroy the pool and datasets
    if [[ "$FS_TYPE" == "zfs" ]]; then
        info "Destroying ZFS pool and datasets..."
        zpool destroy "$ZFS_POOL" || true
    fi

    # Remove the partitions created (if any)
    info "Deleting partitions from disk..."
    parted "$DISK_PATH" -- rm 1 || true
    parted "$DISK_PATH" -- rm 2 || true

    # Optionally, reset the partition table to GPT
    info "Resetting partition table to GPT..."
    parted "$DISK_PATH" -- mklabel gpt || true

    info "Cleanup complete."
}

# Trap errors and invoke cleanup function
trap cleanup ERR

# Main script
check_root
partition_disk
setup_filesystem
generate_nixos_config
install_nixos
