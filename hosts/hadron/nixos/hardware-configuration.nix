{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems."/" = {
    device = "rpool/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/ESP";
    fsType = "vfat";
    options = [
      "fmask=002"
      "dmask=002"
    ];
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

  fileSystems."/tmp" =
    { device = "rpool/tmp";
      fsType = "zfs";
    };

  fileSystems."/var/log" =
    { device = "rpool/volatile-log";
      fsType = "zfs";
    };

#  swapDevices =
#    [ { device = "/dev/disk/by-uuid/c29f5522-3307-4df8-a60d-f6db3f4fbf25"; priority = 20; }
#      { device = "/dev/disk/by-uuid/72f4cf01-fc2a-4c74-8c1c-d3785a8e313f"; priority = 10; }
#    ];


  zramSwap.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth.enable = false;
    graphics.enable = true;
  };
}
