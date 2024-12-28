{ config, pkgs, lib, ... }:

with lib;

{
  boot = {
    kernelModules = [ "kvm-intel" ];
    
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];

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
