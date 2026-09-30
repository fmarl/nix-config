{
  lib,
  pkgs,
  users,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/share/zsh" ];
  };

  users = {
    users = lib.mapAttrs (_: u: {
      isNormalUser = true;
      description = u.fullName;
      extraGroups = [
        "wheel"
        "tss"
      ];
      inherit (u) uid;
      shell = pkgs.zsh;
    }) users;
  };
}
