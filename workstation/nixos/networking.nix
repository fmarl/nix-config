{ config, pkgs, lib, ... }:
{
  networking = {
    hostName = "workstation";
    hostId = "04686870";

    extraHosts =
      ''
        192.168.0.2 svc
      '';

    firewall = {
      enable = false;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };

    interfaces.enp5s0.ipv4.addresses = [{
      address = "192.168.0.200";
      prefixLength = 24;
    }];

    defaultGateway = "192.168.0.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];

    useDHCP = lib.mkDefault false;

    timeServers = [
      "0.de.pool.ntp.org"
      "1.de.pool.ntp.org"
      "2.de.pool.ntp.org"
      "3.de.pool.ntp.org"
    ];
  };
}
