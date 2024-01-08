{ config, pkgs, lib, ... }:
{
  networking = {
    hostName = "zen";
    hostId = "04686870";
    
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };

    useDHCP = lib.mkDefault true;
  };
}
