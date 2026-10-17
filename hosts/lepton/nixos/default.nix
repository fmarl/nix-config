{ lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelModules = [ "kvm-intel" ];

    initrd.availableKernelModules = [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
      "sdhci_pci"
    ];
  };

  networking = {
    hostId = "3265c4e6";

    networkmanager = {
      enable = true;
      wifi = {
        macAddress = "random";
        backend = "iwd";
      };
    };

    wireless.iwd.settings.General.AddressRandomization = "once";

    useDHCP = lib.mkDefault true;
  };

  environment.systemPackages = [ pkgs.vim ];

  services.blueman.enable = true;
}
