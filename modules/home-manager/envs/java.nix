{
	pkgs,
	lib,
	config,
	...
}:

with lib;

let
	cfg = config.modules.envs.java;
in
{
  options.modules.envs.java.enable = mkEnableOption "Install and configure Java";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jdt-language-server
      openjdk25
      gradle
      maven
    ];
  };
}
