{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.envs.terraform;
in
{
  options.modules.envs.terraform.enable =
    lib.mkEnableOption "Install and configure terraform (via tenv)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tenv
      terraform-ls
    ];
  };
}
