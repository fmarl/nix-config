
{
  pkgs,
  config,
  user,
  users,
  ...
}:
let
  me = users.${user};
in
{
  modules = {
    zsh.enable = true;
    librewolf.enable = true;
    gnome.enable = true;
    lf.enable = true;
    emacs.enable = true;
    theme.enable = true;
  };

  fonts.fontconfig.enable = true;

  programs = {
    ssh.settings."workstation" = {
      hostname = "192.168.0.200";
      user = "marrero";
      hashKnownHosts = true;
      forwardAgent = false;
      compression = false;
      forwardX11 = false;
      forwardX11Trusted = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 2;
      controlPersist = "no";
      identityFile = config.sops.secrets.ssh.path;
    };

    git.settings = {
      pull.rebase = true;

      format.subjectPrefix = "PATCH";
    };
  };

  home.packages = with pkgs; [
    signal-desktop
    telegram-desktop
    guile
  ];
}
