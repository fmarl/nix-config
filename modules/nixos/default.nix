{ self, inputs, host, ... }:
{
  imports = [ ./optional ./globals ];

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

  networking.hostName = host;

  time.timeZone = "Europe/Berlin";

  console.keyMap = "us-acentos";

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

  systemd.coredump.enable = true;

  system.stateVersion = "24.05";
}
