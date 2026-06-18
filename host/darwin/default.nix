{
  pkgs,
  vars,
  ...
}:
{
  # Determinate Nix manages the daemon, so disable nix-darwin's nix module.
  nix.enable = false;

  networking.hostName = vars.hostname;

  users.users.${vars.user}.home = vars.homeDir;

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    aporetic
    font-awesome
  ];

  system.stateVersion = 6;
  nixpkgs.hostPlatform = vars.system;
}
