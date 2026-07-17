{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.envs.node;
in
{
  options.modules.envs.node.enable = lib.mkEnableOption "Install and configure Node.JS";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs
    ];
  };
}
