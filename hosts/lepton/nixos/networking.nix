{ lib, ... }:
{
  networking = {
    hostId = "3265c4e6";

    networkmanager = {
      enable = true;
      wifi = {
        macAddress = "random";
        backend = "iwd";
      };
    };

    wireless.iwd.settings.General.AddressRandomization = "once";

    useDHCP = lib.mkDefault true;
  };
}
