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
      device = "/dev/disk/by-uuid/E159-2BB7";
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

  fileSystems."/mnt/minio" =
    {
      device = "/dev/disk/by-uuid/5ae78199-524e-4a99-9c66-aa6ae5ad5a4c";
      fsType = "xfs";
    };

  fileSystems."/persist" =
    {
      device = "rpool/safe/persist";
      fsType = "zfs";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/51fc34a7-6d37-4f8b-b356-8a293aadbf18"; }];

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
