{ inputs, host, ... }:
{
  imports = [ ./services ./programs ];

  sops = {
    defaultSopsFile = "${inputs.secrets}/systems/${host}.yaml";

    secrets = {
      root-password = {
        neededForUsers = true;
      };

      user-password = {
        neededForUsers = true;
      };
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };

    settings = {
      trusted-users = [ "root" "marrero" ];
      allowed-users = [ "@wheel" ];
    };

    extraOptions = "experimental-features = nix-command flakes";

    optimise.automatic = true;
  };

  networking.hostName = host;

  system.stateVersion = "24.05";

  security.sudo.execWheelOnly = true;

  time.timeZone = "Europe/Berlin";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  systemd = {
    coredump.enable = false;
  };
}
