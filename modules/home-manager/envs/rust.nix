{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.envs.rust;
in
{
  options.modules.envs.rust.enable = lib.mkEnableOption "Install and configure Rust";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
        "rust-analyzer"
      ])
    ];
  };
}
