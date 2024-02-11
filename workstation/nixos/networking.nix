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
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };

    useDHCP = lib.mkDefault true;
  };
}
