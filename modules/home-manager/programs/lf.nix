{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.lf;
in
{
  options.modules.lf.enable = mkEnableOption "Install and configure lf";

  config = mkIf cfg.enable {
    programs.lf = {
      enable = true;

      extraConfig = ''
        map f $$EDITOR $(fzf)
          
      '';
    };
  };
}
