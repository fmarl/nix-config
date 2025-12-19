{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.envs.python;
in
{
  options.modules.envs.python.enable = mkEnableOption "Install and configure Python";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (python312.withPackages (python-pkgs: [
        python-pkgs.black
      	python-pkgs.pylint
      	python-pkgs.ruff
      	python-pkgs.python-lsp-ruff
      ]))
      pipenv
      pyenv
    ];
  };
}
