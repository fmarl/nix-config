{ lib, pkgs }:
let
  c = (import ./colors.nix).dark;

  settings = {
    tb = "#${c.bg_1}";
    tf = "#${c.br_blue}";
    fb = "#${c.bg_1}";
    ff = "#${c.fg_0}";
    cb = "#${c.bg_1}";
    cf = "#${c.cursor}";
    nb = "#${c.bg_0}";
    nf = "#${c.fg_1}";
    ab = "#${c.bg_0}";
    af = "#${c.fg_1}";
    hb = "#${c.bg_region}";
    hf = "#${c.fg_0}";
    sb = "#${c.bg_accent}";
    sf = "#${c.fg_0}";
    fbb = "#${c.bg_0}";
    fbf = "#${c.yellow}";
    scb = "#${c.bg_1}";
    scf = "#${c.bg_active}";
    bdr = "#${c.border}";
    fn = "Aporetic Sans Mono 12";
    line-height = 26;
    prompt = "λ ~>";
  };

  args = lib.concatStringsSep " " (
    lib.mapAttrsToList (k: v: "--${k} ${lib.escapeShellArg (toString v)}") settings
  );
in
{
  inherit settings;

  # Wrapper with the settings baked in, so compositors don't depend on BEMENU_OPTS
  run = pkgs.writeShellScript "bemenu-run" ''
    exec ${pkgs.bemenu}/bin/bemenu-run ${args} "$@"
  '';
}
