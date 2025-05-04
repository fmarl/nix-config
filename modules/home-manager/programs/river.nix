{ self, config, lib, pkgs, inputs, ... }:

with lib;

let
  colorscheme = import ./../../colors.nix;
  cfg = config.modules.river;
in
{
  options.modules.river.enable = mkEnableOption "Install and configure river";

  config = mkIf cfg.enable
    {
      programs = {
        alacritty.enable = true;
        bemenu.enable = true;
        ranger.enable = true;
        zathura.enable = true;
        mpv.enable = true;
        imv.enable = true;
      };

      home = {
        packages = (with pkgs; [
          wl-clipboard
        ]);
      };

      services = {
        mako = {
          enable = true;

          backgroundColor = "#${colorscheme.dark.bg_2}";
          borderColor = "#${colorscheme.dark.bg_1}";
          borderRadius = 12;
          progressColor = "#${colorscheme.dark.br_cyan}";
        };
      };

      xdg.configFile."river/init" = {
        executable = true;
        text = ''
#!/bin/sh

riverctl set-keyboard-layout 0 us altgr-intl

### Launcher (bemenu) ###
riverctl map normal Super P spawn bemenu-run

### Terminal ###
riverctl map normal Super+Shift Return spawn alacritty

### Close window ###
riverctl map normal Super+Shift C close
riverctl map normal Super Q exit

### Ranger ###
riverctl map normal Super+Shift D spawn alacritty -e ranger

riverctl map normal $mod H move left 100
riverctl map normal $mod L move right 100
riverctl map normal $mod J move down 100
riverctl map normal $mod K move up 100

riverctl map normal Super+Shift H send-layout-command rivertile "move left"
riverctl map normal Super+Shift L send-layout-command rivertile "move right"
riverctl map normal Super+Shift J send-layout-command rivertile "move down"
riverctl map normal Super+Shift K send-layout-command rivertile "move up"

for i in $(seq 1 9); do
  tags=$((1 << ($i - 1)))

  # Super+[1-9] to focus tag [0-8]
  riverctl map normal Super $i set-focused-tags $tags

  # Super+Shift+[1-9] to tag focused view with tag [0-8]
  riverctl map normal Super+Shift $i set-view-tags $tags

  # Super+Control+[1-9] to toggle focus of tag [0-8]
  riverctl map normal Super+Control $i toggle-focused-tags $tags

  # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
  riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
done

riverctl default-layout rivertile
rivertile -view-padding 6 -outer-padding 6 &
        '';
      };
   };
}
