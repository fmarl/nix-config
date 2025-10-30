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
        set hidden 1
        set showdirfirst 1
        set sort name

        map gg top
        map G bottom

        map D delete
        map yy yank
        map pp paste
        map rr rename

        cmd fzf_select ''${{
            lf -remote "send select '$(
               FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git' --glob '!.direnv' --glob '!.cache'" fzf
            )'"
        }}

        map f fzf_select
      '';
    };
  };
}
