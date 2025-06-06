{ self, config, lib, pkgs, inputs, ... }:

with lib;

let
  colorscheme = import ./../../colors.nix;
  cfg = config.modules.gnome;
in {
  options.modules.gnome.enable = mkEnableOption "Install and configure gnome";

  config = mkIf cfg.enable {
    programs = {
      alacritty.enable = true;
      zathura.enable = true;
      mpv.enable = true;
    };
  };
}
