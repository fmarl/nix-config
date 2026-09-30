{ pkgs, ... }:
{
  modules = {
    zsh.enable = true;
    librewolf.enable = true;
    niri.enable = true;
    lf.enable = true;
    emacs.enable = true;
    waybar.enable = true;
    theme.enable = true;
  };

  home.packages = with pkgs; [
    signal-desktop
  ];
}
