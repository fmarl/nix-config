{ self, inputs, host, ... }:
{
  imports = [ ./services ./programs ];

  networking = {
    hostName = host;

    nameservers = [ "1.1.1.1" "8.8.8.8" ];

    timeServers = [
      "0.de.pool.ntp.org"
      "1.de.pool.ntp.org"
      "2.de.pool.ntp.org"
      "3.de.pool.ntp.org"
    ];
  };

  sops = {
    defaultSopsFile = "${self}/hosts/${host}/secrets.yaml";

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

  time.timeZone = "Europe/Berlin";

  console = {
    keyMap = "us-acentos";
  };

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

  security.sudo.execWheelOnly = true;

  systemd = {
    coredump.enable = true;
  };

  system.stateVersion = "24.05";
}
