{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/356cd7c2-b018-45bf-84aa-62aa91ab4c20";

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [ "defaults" "size=2G" "mode=755" ];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/41bb8a88-80c5-43dc-b4ba-97f6a22f9bc1";
      fsType = "xfs";
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/220F-1456";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" "noexec" "nodev" "nosuid" ];
    };
  };

  zramSwap.enable = true;

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth.enable = false;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vulkan-validation-layers
      ];
    };
  };
}
