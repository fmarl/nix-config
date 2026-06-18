{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.envs.sec;
in
{
  options.modules.envs.sec.enable = lib.mkEnableOption "Install and configure a security testing env";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      binwalk
      sqlmap
      feroxbuster
    ];
  };
}
