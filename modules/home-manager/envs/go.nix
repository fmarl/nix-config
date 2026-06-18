{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.envs.go;
in
{
  options.modules.envs.go.enable = lib.mkEnableOption "Install and configure Go";

  config = lib.mkIf cfg.enable {
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
