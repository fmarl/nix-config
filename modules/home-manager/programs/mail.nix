{ pkgs, lib, config, nixosConfigurations, ... }:

with lib;

let cfg = config.modules.mail;

in {
  options.modules.mail.enable = mkEnableOption "Install and configure mail";

  options.modules.mail.password = mkOption {
    type = types.str;
    description = "Set the password for your mail-account.";
    default = "";
  };

  config = mkIf cfg.enable {
    accounts.email = {
      maildirBasePath = ".maildir";
      accounts.ionos = {
        primary = true;
        realName = "Florian Marrero Liestmann";
        address = "f.m.liestmann@fx-ttr.de";
        userName = "f.m.liestmann@fx-ttr.de";

        gpg = {
          key = "D1912EEBC3FBEBB4";
          signByDefault = true;
        };

        msmtp.enable = true;

        mbsync = {
          enable = true;
          create = "maildir";
        };

        folders = {
          inbox = "Inbox";
          sent = "Gesendete Objekte";
          trash = "Papierkorb";
          drafts = "Entwürfe";
        };

        neomutt = {
          enable = true;
          mailboxName = "Inbox";

          extraConfig = ''
            subscribe kernel-janitors@vger.kernel.org
            color index color42 default "~C kernel-janitors@vger.kernel.org"

            subscribe linux-hardening@vger.kernel.org
            color index color30 default "~C linux-hardening@vger.kernel.org"

            subscribe kernel-hardening@lists.openwall.com
            color index color26 default "~C linux-hardening@vger.kernel.org"

            lists .*@vger.kernel.org

            set edit_headers = yes
            set charset = UTF-8
            unset use_domain
            set use_from = yes
            set index_format='%4C %Z %<[y?%<[m?%<[d?%[%H:%M ]&%[%a %d]>&%[%b %d]>&%[%m/%y ]> %-15.15L (%?l?%4l&%4c?) %s'
          '';
        };

        imap = {
          host = "imap.ionos.de";
          port = 993;
        };

        smtp = {
          host = "smtp.ionos.de";
          port = 465;
        };

        imapnotify = {
          enable = true;
          boxes = [ "Inbox" ];
          onNotifyPost = ''
            ${pkgs.libnotify}/bin/notify-send "New mail arrived."
          '';
        };

        signature = {
          text = "4116 19F1 14F9 83A9 7FCE 16FC D191 2EEB C3FB EBB4";
          showSignature = "append";
        };

        passwordCommand = "cat ${cfg.password}";
      };
    };

    services = {
      mbsync.enable = true;
      imapnotify.enable = true;
    };

    programs = {
      neomutt = {
        enable = true;
        vimKeys = true;
        sidebar.enable = true;
        sort = "reverse-date";
      };

      mbsync.enable = true;
      msmtp.enable = true;
    };

    home.packages = with pkgs; [ openssl ];
  };
}
