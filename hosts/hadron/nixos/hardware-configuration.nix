{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/ESP";
    fsType = "vfat";
    options = [
      "fmask=002"
      "dmask=002"
    ];
  };

  fileSystems."/" = {
    device = "rpool/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/home";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "rpool/persist";
    fsType = "zfs";
  };

  zramSwap.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth.enable = false;
    graphics.enable = true;
  };
}
