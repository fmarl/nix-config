{
  pkgs,
  flib,
  user,
  config,
  bemenu,
  ...
}:
{
  imports = flib.importDir ./.;

  programs = {
    gpg = {
      enable = true;

      # https://support.yubico.com/hc/en-us/articles/4819584884124-Resolving-GPG-s-CCID-conflicts
      scdaemonSettings = {
        disable-ccid = true;
      };

      # https://github.com/drduh/config/blob/master/gpg.conf
      settings = {
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        charset = "utf-8";
        fixed-list-mode = true;
        no-comments = true;
        no-emit-version = true;
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = true;
        require-cross-certification = true;
        no-symkey-cache = true;
        use-agent = true;
        throw-keyids = true;
      };
    };

    fzf = {
      enable = true;
      defaultCommand = "rg --files --hidden --glob '!.git' --glob '!.direnv' --glob '!.cache'";
      fileWidget.command = config.programs.fzf.defaultCommand;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    maxCacheTtl = 1800;
    enableSshSupport = true;
    pinentry.package = bemenu.pinentry;
    extraConfig = "allow-emacs-pinentry";
  };

  # The system's nix.gc does not reach the home-manager profiles
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "26.05";
    packages = with pkgs; [
      htop
      ripgrep
    ];
  };
}
