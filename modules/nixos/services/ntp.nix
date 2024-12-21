{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.ntp;

in {
  options.modules.ntp.enable = mkEnableOption "Install and configure ntp";

  config = mkIf cfg.enable {
    networking.timeServers = [
      "0.de.pool.ntp.org"
      "1.de.pool.ntp.org"
      "2.de.pool.ntp.org"
      "3.de.pool.ntp.org"
    ];

    time.timeZone = "Europe/Berlin";
  };
}
