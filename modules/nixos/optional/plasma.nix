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
    services = {
      desktopManager.plasma6.enable = true;

      displayManager.sddm.enable = true;

      displayManager.sddm.wayland.enable = true;
    };
  };
}
