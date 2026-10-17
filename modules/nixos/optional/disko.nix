# Declarative disk layout, applied by nixos-anywhere or disko-install when a
# host is installed. Both layouts are encrypted, the passphrase is read from
# /tmp/secret.key while formatting and asked for at boot afterwards.
{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.disko;
  keyFile = "/tmp/secret.key";

  esp = {
    size = "1G";
    type = "EF00";
    content = {
      type = "filesystem";
      format = "vfat";
      mountpoint = "/boot";
      mountOptions = [
        "umask=0077"
        "noexec"
        "nosuid"
        "nodev"
      ];
    };
  };

  legacyDataset = mountpoint: options: {
    type = "zfs_fs";
    inherit mountpoint;
    options = {
      mountpoint = "legacy";
    }
    // options;
  };

  zfs = {
    disk.main.content.partitions.root = {
      size = "100%";
      content = {
        type = "zfs";
        pool = "rpool";
      };
    };

    zpool.rpool = {
      type = "zpool";
      options.ashift = "12";
      rootFsOptions = {
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "file://${keyFile}";
        compression = "zstd";
        acltype = "posixacl";
        xattr = "sa";
        dnodesize = "auto";
        normalization = "formD";
        relatime = "on";
        canmount = "off";
        mountpoint = "none";
      };
      # Ask for the passphrase at boot, not for the key file of the installer
      postCreateHook = "zfs set keylocation=prompt rpool";

      datasets = {
        root = legacyDataset "/" { };
        nix = legacyDataset "/nix" { };
        home = legacyDataset "/home" { "com.sun:auto-snapshot" = "true"; };
        persist = legacyDataset "/persist" { "com.sun:auto-snapshot" = "true"; };

        # Keeps the pool usable (e.g. for deleting files) when it runs full
        reserved = {
          type = "zfs_fs";
          options = {
            canmount = "off";
            mountpoint = "none";
            refreservation = "10G";
          };
        };
      };
    };
  };

  luks = format: {
    disk.main.content.partitions.root = {
      size = "100%";
      content = {
        type = "luks";
        name = "cryptroot";
        passwordFile = keyFile;
        settings = {
          allowDiscards = true;
          bypassWorkqueues = true;
        };
        content = {
          type = "filesystem";
          inherit format;
          mountpoint = "/";
          extraArgs = [
            "-L"
            "nixos"
          ];
        };
      };
    };
  };
in
{
  options.modules.disko = {
    enable = lib.mkEnableOption "the disk layout of this host via disko";

    device = lib.mkOption {
      type = lib.types.str;
      example = "/dev/nvme0n1";
      description = "Disk to install to, preferably by /dev/disk/by-id";
    };

    layout = lib.mkOption {
      type = lib.types.enum [
        "zfs"
        "ext4"
        "xfs"
      ];
      default = "zfs";
      description = "ZFS with native encryption, or ext4 or xfs on LUKS2";
    };
  };

  config = lib.mkIf cfg.enable {
    disko.devices = lib.mkMerge [
      {
        disk.main = {
          type = "disk";
          inherit (cfg) device;
          content = {
            type = "gpt";
            partitions.ESP = esp;
          };
        };
      }
      (if cfg.layout == "zfs" then zfs else luks cfg.layout)
    ];
  };
}
