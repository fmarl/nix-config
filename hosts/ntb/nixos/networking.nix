{ lib, ... }:
{
  networking = {
    hostId = "04686870";

    networkmanager = {
      enable = true;
      wifi = {
        macAddress = "random";
        backend = "iwd";
      };
    };

    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          AddressRandomization = "once";
        };
        Network = {
          EnableIPv6 = false;
          NameResolvingService = "systemd";
        };
      };
    };

    firewall = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };

    useDHCP = lib.mkDefault true;
  };
}
