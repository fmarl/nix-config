{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.envs.clojure;
in
{
  options.modules.envs.clojure.enable = lib.mkEnableOption "Install and configure Clojure";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      clojure
      rlwrap
      clj-kondo
      cljstyle
      clojure-lsp
      leiningen
    ];
  };
}
