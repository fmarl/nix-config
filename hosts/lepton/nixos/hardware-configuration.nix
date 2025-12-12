{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/3c943af2-73dc-44bc-999a-fa838d561716";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/cf0cf877-a9bf-4132-8537-3f5721108d37";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress-force=zstd"
      "noatime"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };
  
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/cf0cf877-a9bf-4132-8537-3f5721108d37";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress-force=zstd"
      "noatime"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/cf0cf877-a9bf-4132-8537-3f5721108d37";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress-force=zstd"
      "noatime"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/cf0cf877-a9bf-4132-8537-3f5721108d37";
    fsType = "btrfs";
    options = [
      "subvol=@persist"
      "compress-force=zstd"
      "noatime"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/cf0cf877-a9bf-4132-8537-3f5721108d37";
    fsType = "btrfs";
    options = [
      "subvol=@volatile-log"
      "compress-force=zstd"
      "noatime"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CE94-679E";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  zramSwap.enable = true;

  swapDevices = [ { device = "/dev/disk/by-uuid/98f80efd-ddbe-4556-b70a-e317fe8c539d"; priority = 20; } ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth.enable = true;
    opengl.enable = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [ vulkan-validation-layers ];
    };
  };
}
