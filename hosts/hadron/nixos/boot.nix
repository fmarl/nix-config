{ pkgs, lib, ... }:
{
  boot = {
    kernelModules = [ "kvm-amd" ];

    initrd = {
      includeDefaultModules = false;
      availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "nvme"
      ];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    extraModulePackages = [ ];

    tmp.cleanOnBoot = true;
  };
}
