{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.envs.ocaml;
in
{
  options.modules.envs.ocaml.enable = mkEnableOption "Install and configure OCaml";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ocaml
      dune_3
      ocamlformat
      ocamlPackages.ocaml-lsp
      ocamlPackages.utop
    ];
  };
}
