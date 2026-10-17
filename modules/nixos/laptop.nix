{ config, lib, ... }:
{
  services = lib.mkIf config.machine.laptop {
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };
}
