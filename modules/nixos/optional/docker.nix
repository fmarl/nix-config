{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.docker;

in {
  options.modules.docker.enable = mkEnableOption "Install and configure docker";

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
