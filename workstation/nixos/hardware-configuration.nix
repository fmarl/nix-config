{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  fileSystems."/" =
    {
      device = "rpool/local/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/B4FE-552F";
      fsType = "vfat";
      options = [ "fmask=002" "dmask=002" ];
    };

  fileSystems."/nix" =
    {
      device = "rpool/local/nix";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "rpool/safe/home";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    {
      device = "rpool/safe/persist";
      fsType = "zfs";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/e265876b-a241-40c6-993a-d97f565b21b2"; }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    pulseaudio.enable = false;
    bluetooth.enable = false;

    graphics = {
      enable = true;
    };

    nvidia = {
      modesetting.enable = true;

      open = false;
      nvidiaSettings = false;
      powerManagement.enable = false;
    };
  };
}
