{
  pkgs,
  user,
  config,
  ...
}:
{
  imports = [
    ./sops.nix
    ./ssh.nix
    ./git.nix
  ];

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
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gnome3;
    extraConfig = "allow-emacs-pinentry";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  xdg.userDirs = {
    enable = true;
    download = "${config.home.homeDirectory}/downloads";
  };

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "26.05";
    packages = with pkgs; [
      htop
      ripgrep

      (writeShellScriptBin "nrun" ''
        NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#$1
      '')
      (writeShellScriptBin "metaflake" ''
        nix develop github:fmarl/metaflakes#$1 --no-write-lock-file
      '')
    ];
  };
}
