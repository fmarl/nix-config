{ pkgs, lib, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_hardened;

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
