{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.envs.lisp;
in
{
  options.modules.envs.lisp.enable = lib.mkEnableOption "Install and configure Lisp";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      sbcl
    ];
  };
}
