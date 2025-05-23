{ config, pkgs, lib, ... }:

with lib;
let
  kernel = (pkgs.linuxManualConfig {
    pname = builtins.hashString "sha256" (builtins.readFile ./kernel.config);
    src = pkgs.linux.src;
    version = pkgs.linux.version;
    modDirVersion = pkgs.linux.modDirVersion;

    configfile = ./kernel.config;
    kernelPatches = [ ];

    allowImportFromDerivation = true;
  });
in {
  boot = {
    kernelPackages = pkgs.linuxPackages_hardened;

    kernelModules = [ "kvm-amd" ];

    initrd = {
      includeDefaultModules = false;
      availableKernelModules =
        [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "nvme" ];

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
