{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.username = "spark";
  home.homeDirectory = "/home/spark";

  home.stateVersion = "22.11";

  home.packages = [
    pkgs.spark
    pkgs.hyperledger-fabric
    pkgs.openjdk14_headless
  ];


  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Florian Büstgens";
    userEmail = "fb@fx-ttr.de";
  };

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    initExtra = ''
      autoload -U promptinit && 
      promptinit && 
      prompt suse && 
      setopt prompt_sp
    '';

    shellAliases = {
      ll = "ls -l";
      rebuild = "sudo nixos-rebuild switch";
    };
  };
}
