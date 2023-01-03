{ config, pkgs, lib, ... }:

{
  services.openntpd.enable = true;

  networking.timeServers = [
    "0.de.pool.ntp.org"
    "1.de.pool.ntp.org"
    "2.de.pool.ntp.org"
    "3.de.pool.ntp.org"
  ];

  time.timeZone = "Europe/Berlin";
}
