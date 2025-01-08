{
  boot = {
    kernelModules = [ "kvm-intel" ];

    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];

    extraModulePackages = [ ];
  };
}
