{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.envs.go;
in
{
  options.modules.envs.go.enable = mkEnableOption "Install and configure Go";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      gopls
      gotools
      go-tools
      gopkgs
      golangci-lint
      delve
      gotests
    ];
  };
}
