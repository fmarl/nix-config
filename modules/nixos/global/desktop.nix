{ lib, pkgs, ... }:
{
  environment = {
    defaultPackages = lib.mkForce [ ];
    systemPackages = [ pkgs.home-manager ];
  };

  fonts.packages = with pkgs; [
    aporetic
    font-awesome
  ];

  services = {
    dbus = {
      enable = true;
      # gcr-prompter for pinentry-gnome3
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
}
