{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.envs.rust;
in
{
  options.modules.envs.rust.enable = mkEnableOption "Install and configure Rust";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      rust-analyzer-nightly
    ];
  };
}
