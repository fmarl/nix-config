{ config, pkgs, lib, ... }:

with lib;

{
  boot = {
    kernelModules = [ "kvm-amd" ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "lz4" "z3fold" ];
      kernelModules = [ "lz4" "z3fold" ];

      preDeviceCommands = ''
        printf lz4 > /sys/module/zswap/parameters/compressor
        printf z3fold > /sys/module/zswap/parameters/zpool
      '';

      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r rpool/local/root@blank
      '';
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    extraModulePackages = [ ];

    tmp.cleanOnBoot = true;
  };
}
