{
  pkgs,
  config,
  ...
}:
{
  modules = {
    zsh.enable = true;
    librewolf.enable = true;
    lf.enable = true;
    emacs.enable = true;
    theme.enable = true;
    niri.enable = true;
    waybar = {
      enable = true;
      mobile = true;
    };
  };

  programs = {
    ssh.settings."workstation" = {
      hostname = "192.168.0.200";
      user = "marrero";
      hashKnownHosts = true;
      serverAliveCountMax = 2;
      identityFile = config.sops.secrets.ssh.path;
      addKeysToAgent = "yes";
    };

    git.settings = {
      pull.rebase = true;

      format.subjectPrefix = "PATCH";
    };
  };

  home.packages = with pkgs; [
    signal-desktop
  ];
}
