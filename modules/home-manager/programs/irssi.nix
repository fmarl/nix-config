{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.irssi;

in {
  options.modules.irssi.enable = mkEnableOption "Install and configure irssi";
  options.modules.irssi.user = mkOption {
    type = types.str;
    description = "Set the nick and name variable";
    default = "";
  };

  config = mkIf cfg.enable {
    file = {
      ".irssi" = {
        source = inputs.irssi-themes;
        recursive = true;
      };
    };

    programs.irssi = {
      enable = true;
      networks =
        {
          libera = {
            type = "IRC";
            nick = cfg.user;
            name = cfg.user;

            server = {
              address = "irc.libera.chat";
              port = 6697;
              autoConnect = false;
            };

            channels = {
              nixos.autoJoin = true;
            };
          };

          hackint = {
            type = "IRC";
            nick = cfg.user;
            name = cfg.user;
            
            server = {
              address = "irc.hackint.org";
              port = 6697;
              autoConnect = false;
            };
          };
        };
        extraConfig = ''
settings = {
  core = { real_name = "ef von ix"; user_name = "${cfg.user}"; nick = "${cfg.user}"; };
  "fe-text" = { actlist_sort = "refnum"; };
  "fe-common/core" = { theme = "screwer-redux"; };
};
        '';
    };
  };
}
