#!/usr/bin/env bash

set -euo pipefail

export COLOR_RESET="\033[0m"
export RED_BG="\033[41m"
export BLUE_BG="\033[44m"
export DISK=$1
export FS_TYPE=${2:-zfs}
export HOSTNAME=$3

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

function validate_inputs {
    if [[ -z "$DISK" ]]; then
        err "Missing argument. Expected block device name, e.g., 'sda'"
        exit 1
    fi

    if [[ -z "$HOSTNAME" ]]; then
        err "Missing argument. Expected hostname, e.g., 'nixos'"
        exit 1
    fi

    export DISK_PATH="/dev/${DISK}"

    if [[ ! -b "$DISK_PATH" ]]; then
        err "Invalid argument: '${DISK_PATH}' is not a block special file"
        exit 1
    fi
}

function partition_disk {
    info "Partitioning disk ${DISK_PATH} for UEFI (GPT) ..."
    parted "$DISK_PATH" -- mklabel gpt
    parted "$DISK_PATH" -- mkpart primary 512MiB 100%
    parted "$DISK_PATH" -- mkpart ESP fat32 1MiB 512MiB
    parted "$DISK_PATH" -- set 2 boot on
    export DISK_PART_ROOT="${DISK_PATH}1"
    export DISK_PART_BOOT="${DISK_PATH}2"

    info "Formatting boot partition ..."
    mkfs.fat -F 32 -n boot "$DISK_PART_BOOT"
}

function setup_filesystem {
    case "$FS_TYPE" in
        zfs)
            setup_zfs
            ;;
        ext4)
            setup_ext4
            ;;
        *)
            err "Unsupported filesystem type: ${FS_TYPE}"
            exit 1
            ;;
    esac
}

function setup_zfs {
    info "Setting up ZFS on ${DISK_PART_ROOT} ..."

    export ZFS_POOL="rpool"
    export ZFS_LOCAL="${ZFS_POOL}/local"
    export ZFS_DS_ROOT="${ZFS_LOCAL}/root"
    export ZFS_DS_NIX="${ZFS_LOCAL}/nix"
    export ZFS_SAFE="${ZFS_POOL}/safe"
    export ZFS_DS_HOME="${ZFS_SAFE}/home"
    export ZFS_DS_PERSIST="${ZFS_SAFE}/persist"
    export ZFS_BLANK_SNAPSHOT="${ZFS_DS_ROOT}@blank"

    zpool create -o ashift=13 -o atime=off -o xattr=sa -o compression=lz4 -f "$ZFS_POOL" "$DISK_PART_ROOT"

    info "Creating ZFS datasets ..."
    zfs create -p -o mountpoint=legacy "$ZFS_DS_ROOT"
    zfs set xattr=sa "$ZFS_DS_ROOT"
    zfs set acltype=posixacl "$ZFS_DS_ROOT"
    zfs snapshot "$ZFS_BLANK_SNAPSHOT"

    zfs create -p -o mountpoint=legacy "$ZFS_DS_NIX"
    zfs set atime=off "$ZFS_DS_NIX"
    zfs create -p -o mountpoint=legacy "$ZFS_DS_HOME"
    zfs create -p -o mountpoint=legacy "$ZFS_DS_PERSIST"

    info "Mounting ZFS datasets ..."
    mount -t zfs "$ZFS_DS_ROOT" /mnt
    mkdir -p /mnt/{boot,nix,home,persist}
    mount -t vfat "$DISK_PART_BOOT" /mnt/boot
    mount -t zfs "$ZFS_DS_NIX" /mnt/nix
    mount -t zfs "$ZFS_DS_HOME" /mnt/home
    mount -t zfs "$ZFS_DS_PERSIST" /mnt/persist

    zfs set com.sun:auto-snapshot=true "$ZFS_DS_HOME"
    zfs set com.sun:auto-snapshot=true "$ZFS_DS_PERSIST"
}

function setup_ext4 {
    info "Setting up ext4 on ${DISK_PART_ROOT} ..."
    mkfs.ext4 -L nixos_root "$DISK_PART_ROOT"

    info "Mounting ext4 filesystem ..."
    mount "$DISK_PART_ROOT" /mnt
    mkdir -p /mnt/boot
    mount "$DISK_PART_BOOT" /mnt/boot
}

function generate_nixos_config {
    info "Generating NixOS configuration ..."
    nixos-generate-config --root /mnt

    info "Prompting for user credentials ..."
    info "Enter password for the root user ..."
    ROOT_PASSWORD_HASH="$(mkpasswd -m sha-512 | sed 's/\$/\\$/g')"

    info "Enter personal user name ..."
    read USER_NAME

    info "Enter password for '${USER_NAME}' user ..."
    USER_PASSWORD_HASH="$(mkpasswd -m sha-512 | sed 's/\$/\\$/g')"

    info "Writing NixOS configuration ..."
    if [[ "$FS_TYPE" == "zfs" ]]; then
        mkdir -p /mnt/persist/etc/nixos
        mv /mnt/etc/nixos/hardware-configuration.nix /mnt/persist/etc/nixos/

        cat <<EOF > /mnt/persist/etc/nixos/configuration.nix
{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/persist/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

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
    else
        mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/

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
    fi
}

function install_nixos {
    info "Installing NixOS ..."
    if [[ "$FS_TYPE" == "zfs" ]]; then
        rm -rf /mnt/etc/nixos/configuration.nix
        ln -s /mnt/persist/etc/nixos/configuration.nix /mnt/etc/nixos/configuration.nix
        nixos-install -I "nixos-config=/mnt/persist/etc/nixos/configuration.nix" --no-root-passwd
    else
        nixos-install --no-root-passwd
    fi
}

# Main script
check_root
validate_inputs
partition_disk
setup_filesystem
generate_nixos_config
install_nixos
