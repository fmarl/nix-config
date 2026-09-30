{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.lf;

  previewer = pkgs.writeShellScript "lf-preview" ''
    case "$(${pkgs.file}/bin/file -Lb --mime-type -- "$1")" in
      text/* | application/json | application/x-*script* | inode/x-empty)
        ${pkgs.bat}/bin/bat --color=always --style=plain --paging=never --line-range=:200 -- "$1"
        ;;
      *)
        ${pkgs.file}/bin/file -Lb -- "$1"
        ;;
    esac
  '';
in
{
  options.modules.lf.enable = lib.mkEnableOption "Install and configure lf";

  config = lib.mkIf cfg.enable {
    programs.lf = {
      enable = true;

      settings = {
        hidden = true;
        dirfirst = true;
        sortby = "name";
      };

      previewer.source = previewer;

      commands.fzf_select = ''
        ''${{
            res="$(FZF_DEFAULT_COMMAND=${lib.escapeShellArg config.programs.fzf.defaultCommand} ${pkgs.fzf}/bin/fzf)"
            [ -n "$res" ] || exit 0
            res="$(printf '%s' "$res" | sed 's/\\/\\\\/g; s/"/\\"/g')"
            lf -remote "send $id select \"$res\""
        }}
      '';

      keybindings = {
        gg = "top";
        G = "bottom";
        D = "delete";
        yy = "copy";
        pp = "paste";
        rr = "rename";
        f = "fzf_select";
      };
    };
  };
}
