{ config, pkgs, lib, ... }:

with lib;

{
  boot = {
    kernelModules = [ "kvm-intel" ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    extraModulePackages = [ ];

    tmp.cleanOnBoot = true;
  };
}
