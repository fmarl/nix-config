{
  lib,
  pkgs,
  theme,
}:
let
  inherit (theme) style;

  settings =
    lib.mapAttrs (_: theme.color) {
      tb = "bg_0";
      tf = "br_blue";
      fb = "bg_0";
      ff = "fg_0";
      cb = "bg_0";
      cf = "cursor";
      nb = "bg_0";
      nf = "dim_0";
      ab = "bg_0";
      af = "dim_0";
      hb = "bg_0";
      hf = "br_blue";
      sb = "bg_accent";
      sf = "fg_0";
      fbb = "bg_0";
      fbf = "yellow";
    }
    // {
      bdr = theme.hairline;
      border = 1;
      fn = "${style.monospaceFont} 10";
      line-height = style.barHeight;
      hp = style.spacing;
    };

  runSettings = {
    ignorecase = true;
    single-instance = true;
    counter = "always";
    prefix = "›";
    prompt = "λ";
  };

  args = lib.cli.toCommandLineShellGNU { };
in
{
  # Wrapper with the settings baked in, so compositors don't depend on BEMENU_OPTS
  run = pkgs.writeShellScript "bemenu-run" ''
    exec ${pkgs.bemenu}/bin/bemenu-run ${args (settings // runSettings)} "$@"
  '';

  # pinentry-bemenu takes its options only from BEMENU_OPTS
  pinentry = pkgs.writeShellApplication {
    name = "pinentry-bemenu";
    text = ''
      export BEMENU_OPTS=${lib.escapeShellArg (args settings)}
      exec ${lib.getExe pkgs.pinentry-bemenu} "$@"
    '';
  };
}
