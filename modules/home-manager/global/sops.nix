{
  config,
  lib,
  host,
  user,
  users,
  ...
}:
{
  sops = {
    # Decrypt with the OpenPGP key on the YubiKey instead of an age key on disk
    gnupg.home = config.programs.gpg.homedir;

    defaultSopsFile = ../../../hosts + "/${host}/secrets.yaml";

    secrets.ssh.path = "/run/user/${toString users.${user}.uid}/secrets/ssh";
  };

  # pinentry needs a running compositor, graphical-session-pre.target is too early
  systemd.user.services.sops-nix = {
    Unit.After = [ "graphical-session.target" ];
    Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
  };
}
