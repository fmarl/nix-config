{ pkgs, lib, nixosConfigurations, ... }:
{
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    enableCompletion = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    sessionVariables = {
      GPG_TTY = "$(tty)";
      CACHIX_AUTH_TOKEN = (builtins.readFile nixosConfigurations.workstation.config.sops.secrets.cachix.path);
    };

    shellAliases = {
      ll = "ls -l";
      nix-search = "nix search nixpkgs";
      nbuild = "sudo nixos-rebuild switch --flake .";
      hbuild = "home-manager switch --flake .";
    };
  };
}
