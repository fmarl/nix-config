{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.envs.python;
in
{
  options.modules.envs.python.enable = lib.mkEnableOption "Install and configure Python";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (python314.withPackages (
        python-pkgs: with python-pkgs; [
          pip
          uv
          ruff
          #python-lsp-ruff
          python-lsp-server
        ]
      ))
      pipenv
      pyenv
    ];
  };
}
