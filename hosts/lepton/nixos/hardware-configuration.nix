{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/58a44003-2288-4059-86cd-126c9d002b30";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5ad944f4-4755-415b-8a63-a6f700a4d9f8";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5B22-48B5";
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
