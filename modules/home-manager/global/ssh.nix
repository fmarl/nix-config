{ config, ... }:
let
  mkGitHost = host: {
    hostname = host;
    user = "git";
    hashKnownHosts = true;
    serverAliveCountMax = 1;
    identityFile = config.sops.secrets.ssh.path;
  };
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = mkGitHost "github.com";
      "codeberg.org" = mkGitHost "codeberg.org";
    };
  };
}
