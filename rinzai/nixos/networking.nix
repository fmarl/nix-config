{ config, pkgs, lib, ... }:
{
  networking = {
    hostName = "rinzai";
    hostId = "8d1f864c";
    
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };

    useDHCP = lib.mkDefault true;
  };
}
