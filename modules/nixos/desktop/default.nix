{
  config,
  lib,
  pkgs,
  flib,
  ...
}:
{
  imports = flib.importDir ./.;

  config = lib.mkIf config.machine.desktop {
    fonts.packages = with pkgs; [
      aporetic
      inter
      font-awesome
    ];

    services = {
      dbus = {
        enable = true;
        # gcr-prompter for gnome-keyring
        packages = [ pkgs.gcr_3 ];
      };

      fwupd.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
  };
}
