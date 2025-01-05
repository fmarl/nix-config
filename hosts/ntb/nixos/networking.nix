{ lib, ... }:
{
  networking = {
    hostId = "04686870";

    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
    };

    useDHCP = lib.mkDefault true;
  };
}
