{
  pkgs,
  self,
  host,
  user,
  ...
}:
{
  imports = [
    ./services
    ./programs
    ./theme.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.gpg = {
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

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-curses;
    extraConfig = ''
      ttyname $GPG_TTY
    '';
  };

  sops = {
    defaultSopsFile = "${self}/hosts/${host}/secrets.yaml";
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
    packages = with pkgs; [
      fzf
      ranger
      ripgrep
      lazygit
    ];
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
