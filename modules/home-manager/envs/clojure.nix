{
	pkgs,
	lib,
	config,
	...
}:

with lib;

let
	cfg = config.modules.envs.clojure;
in
{
  options.modules.envs.clojure.enable = mkEnableOption "Install and configure Clojure";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      openjdk21
      clojure
      rlwrap
      clj-kondo
      cljstyle
      clojure-lsp
    ];
  };
}
