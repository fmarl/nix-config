{ config, ... }:
let
  mkGitHost = host: {
    hostname = host;
    user = "git";
    hashKnownHosts = true;
    forwardAgent = false;
    compression = false;
    forwardX11 = false;
    forwardX11Trusted = false;
    serverAliveInterval = 0;
    serverAliveCountMax = 1;
    controlPersist = "no";
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
