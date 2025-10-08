{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.plasma;
in
{
  options.modules.plasma.enable = mkEnableOption "Install and configure KDE Plasma 6";

  config = mkIf cfg.enable {
    services.kdeconnect.enable = true;
  };
}
