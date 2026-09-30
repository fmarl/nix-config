{
  boot = {
    kernelModules = [ "kvm-amd" ];

    zfs.forceImportRoot = false;

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
  };
}
