{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.envs.sec;
in
  {
    options.modules.envs.sec.enable = mkEnableOption "Install and configure a security testing env";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
	binwalk
	sqlmap
	feroxbuster
      ];
    };
  }
