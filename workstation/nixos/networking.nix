{ config, pkgs, lib, ... }:
{
  networking = {
    hostName = "workstation";
    hostId = "04686870";
    
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };

    useDHCP = lib.mkDefault true;
  };
}
