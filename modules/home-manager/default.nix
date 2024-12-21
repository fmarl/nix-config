{ inputs, host, user, ... }:
{
  imports = [ ./services ./programs ./theme.nix ];

  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = "${inputs.secrets}/systems/${host}.yaml";

    secrets = {
      ssh = {
        path = "/run/user/1000/secrets/ssh";
      };
    };
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "25.05";
  };
  
  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
