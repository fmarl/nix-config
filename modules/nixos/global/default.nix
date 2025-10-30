{
  self,
  host,
  ...
}:
{
  imports = [
    ./nix.nix
    (import ./networking.nix { inherit host; })
    ./boot.nix
    ./security.nix
  ];

  sops = {
    defaultSopsFile = "${self}/hosts/${host}/secrets.yaml";

    secrets = {
      user-password = {
        neededForUsers = true;
      };
    };
  };

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
  
  systemd.coredump.enable = true;

  system.stateVersion = "24.05";
}
