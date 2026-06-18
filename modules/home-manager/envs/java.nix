{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.envs.java;
in
{
  options.modules.envs.java.enable = lib.mkEnableOption "Install and configure Java";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      jdt-language-server
      openjdk25
      gradle
      maven
    ];
  };
}
