{ pkgs, config, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_hardened;

    kernelModules = [ "kvm-intel" "v4l2loopback" ];

    initrd.availableKernelModules = [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
      "sdhci_pci"
    ];

    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  };
}
