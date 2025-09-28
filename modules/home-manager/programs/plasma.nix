{
  config,
  lib,
  user,
  ...
}:

with lib;

let
  cfg = config.modules.plasma;
in
{
  options.modules.plasma.enable = mkEnableOption "Install and configure KDE Plasma 6";

  config = mkIf cfg.enable {
    users.${user}.username.services.kdeconnect.enable = true;
  };
}
