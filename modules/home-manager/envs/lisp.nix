{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.envs.lisp;
in
{
  options.modules.envs.lisp.enable = mkEnableOption "Install and configure Lisp";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sbcl
      chicken
    ];
  };
}
