{
  config,
  lib,
  pkgs,
  ...
}:


let
  cfg = config.modules.alacritty;
in
{
  options.modules.alacritty.enable = lib.mkEnableOption "Install and configure alacritty";

  config = lib.mkIf cfg.enable {
    programs = {
      alacritty = {
	enable = true;

	settings = {
	  general.import = [
	    ./ef_owl.toml
	  ];
	};
      };
    };
  };
}
