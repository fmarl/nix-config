{ pkgs, ... }:
{
  programs.dconf.enable = true;
  services.xserver = {
    enable = true;

    layout = "de";

    displayManager.sddm.enable = true;
    desktopManager.plasma5 = {
      enable = true;
      excludePackages = with pkgs.libsForQt5; [
        elisa
        khelpcenter
        plasma-browser-integration
      ];
    };
  };
}
