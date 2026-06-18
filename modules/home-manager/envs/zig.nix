{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.envs.zig;
in
{
  options.modules.envs.zig.enable = lib.mkEnableOption "Install and configure Zig";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zig
      zls
    ];
  };
}
