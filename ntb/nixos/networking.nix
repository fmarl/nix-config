{ config, pkgs, lib, ... }:
{
  networking = {
    hostName = "ntb";
    hostId = "04686870";
    
    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };

    useDHCP = lib.mkDefault true;
  };
}
