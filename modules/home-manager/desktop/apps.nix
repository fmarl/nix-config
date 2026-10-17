{
  config,
  lib,
  sandbox,
  ...
}:
{
  config = lib.mkIf config.machine.desktop {
    wayland.windowManager.niri.settings._children = [
      {
        window-rule._children = [
          { match._props.app-id = "(?i)signal"; }
          { block-out-from = "screencast"; }
        ];
      }
    ];

    home.packages = [ sandbox.signal-desktop ];

    # Secret service for signal and others
    services.gnome-keyring.enable = true;

    programs = {
      zathura = {
        enable = true;
        package = sandbox.zathura;
      };
      mpv = {
        enable = true;
        package = sandbox.mpv;
      };
      imv = {
        enable = true;
        package = sandbox.imv;
      };
    };
  };
}
