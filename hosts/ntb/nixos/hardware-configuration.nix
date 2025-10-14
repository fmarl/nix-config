{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/a4b3f5a6-764a-45eb-bcdd-d2b9e5d5c665";

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [
        "defaults"
        "size=10G"
        "mode=755"
      ];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/52ec9d7e-b72c-491e-a3bb-1e2f93013942";
      fsType = "xfs";
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7460-3156";

      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
        "noexec"
        "nodev"
        "nosuid"
      ];
    };
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
