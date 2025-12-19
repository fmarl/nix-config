{ pkgs, ... }:
{
  # This looks weird. But it's for determinate nix.
  nix.enable = false;

  networking.hostName = "HGDEMLFR003777";

  users.users."florian.marreroliestmann".home = "/Users/florian.marreroliestmann";

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    aporetic
    font-awesome
  ];

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
