{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.envs.ocaml;
in
{
  options.modules.envs.ocaml.enable = lib.mkEnableOption "Install and configure OCaml";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ocaml
      dune_3
      ocamlformat
      ocamlPackages.ocaml-lsp
      ocamlPackages.utop
    ];
  };
}
