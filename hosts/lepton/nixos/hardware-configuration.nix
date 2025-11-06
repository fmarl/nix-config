{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ca073fd5-a50a-4c19-89ac-3ff42a4fcf3e";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/4636f8ec-643b-4352-b918-b545938b88df";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/ca073fd5-a50a-4c19-89ac-3ff42a4fcf3e";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd:3"
      "noatime"
      "ssd"
      "discard=async"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/ca073fd5-a50a-4c19-89ac-3ff42a4fcf3e";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd:1"
      "noatime"
      "ssd"
      "discard=async"
    ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/ca073fd5-a50a-4c19-89ac-3ff42a4fcf3e";
    fsType = "btrfs";
    options = [
      "subvol=@persist"
      "compress=zstd:3"
      "noatime"
      "ssd"
      "discard=async"
    ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/ca073fd5-a50a-4c19-89ac-3ff42a4fcf3e";
    fsType = "btrfs";
    options = [
      "subvol=@volatile-log"
      "compress=zstd:3"
      "noatime"
      "ssd"
      "discard=async"
    ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/74F0-047D";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  zramSwap.enable = true;

  swapDevices = [ ];

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
