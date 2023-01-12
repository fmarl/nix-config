{ pkgs, ... }: {
  imports = [
    ./../../lib/hm/programs/zsh.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "florian";
  home.homeDirectory = "/home/florian";

  home.stateVersion = "22.11";

  home.packages = (with pkgs; [
    ranger
    tmux
    nixpkgs-fmt
    rnix-lsp
    (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
      ipykernel
      pandas
      scikit-learn
      jupyter
      numpy
      tensorflow
      matplotlib
      seaborn
    ]))
  ]);

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Florian Büstgens";
    userEmail = "fb@fx-ttr.de";
    signing = {
      signByDefault = true;
      key = "865E0BA2011DAEE1A83F895E2EEC4010A0299470";
    };
  };
}
