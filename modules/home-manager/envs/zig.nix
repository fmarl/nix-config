{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.envs.zig;
in
  {
    options.modules.envs.zig.enable = mkEnableOption "Install and configure Zig";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
	zig
	zls
      ];
    };
  }
