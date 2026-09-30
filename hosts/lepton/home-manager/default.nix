{
  pkgs,
  config,
  lib,
  self,
  user,
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
      hostname =
        (lib.head self.nixosConfigurations.hadron.config.networking.interfaces.enp5s0.ipv4.addresses)
        .address;
      inherit user;
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
