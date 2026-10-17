{
  config,
  lib,
  self,
  host,
  user,
  ...
}:
let
  identity = {
    IdentityFile = config.sops.secrets.ssh.path;
    AddKeysToAgent = "yes";
  };

  gitHost = hostname: {
    ${hostname} = identity // {
      HostName = hostname;
      User = "git";
      ServerAliveCountMax = 1;
    };
  };

  # The other hosts of this flake that have a static address
  lanHosts = lib.concatMapAttrs (
    name: nixos:
    let
      addresses = lib.concatMap (i: i.ipv4.addresses) (lib.attrValues nixos.config.networking.interfaces);
    in
    lib.optionalAttrs (name != host && addresses != [ ]) {
      ${name} = identity // {
        HostName = (lib.head addresses).address;
        User = user;
        ServerAliveCountMax = 2;
      };
    }
  ) self.nixosConfigurations;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings =
      gitHost "github.com"
      // gitHost "codeberg.org"
      // lanHosts
      // {
        # Written last by home-manager
        "*" = {
          IdentitiesOnly = true;
          HashKnownHosts = true;
          ServerAliveInterval = 30;
        };
      };
  };
}
