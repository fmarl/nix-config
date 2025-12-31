{ lib, ... }:
{
  networking = {
    hostId = "04686870";

    firewall = {
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };

    interfaces.enp5s0.ipv4.addresses = [
      {
        address = "192.168.0.200";
        prefixLength = 24;
      }
    ];

    defaultGateway = "192.168.0.1";

    useDHCP = lib.mkDefault false;
  };
}
