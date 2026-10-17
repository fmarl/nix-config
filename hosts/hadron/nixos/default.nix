{ lib, primaryUser, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./kernel-modules.nix
  ];

  boot = {
    kernelModules = [ "kvm-amd" ];

    kernelParams = [ "amd_iommu=force_isolation" ];

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

  networking = {
    hostId = "04686870";

    interfaces.enp5s0.ipv4.addresses = [
      {
        address = "192.168.0.200";
        prefixLength = 24;
      }
    ];

    defaultGateway = "192.168.0.1";

    useDHCP = lib.mkDefault false;
  };

  modules.firewall.lanTCPPorts = [ 22 ];

  users.users.${primaryUser} = {
    extraGroups = [ "kvm" ];
    openssh.authorizedKeys.keyFiles = [ ../../lepton/ssh.pub ];
  };

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  services = {
    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };

    openssh = {
      enable = true;
      openFirewall = false;

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AllowUsers = [ primaryUser ];
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        X11Forwarding = false;
      };

      hostKeys = [
        {
          path = "/persist/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };

  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;

      dockerCompat = true;

      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
