{
  imports = [
    ./hardware-configuration.nix
    ./security.nix
    ./services.nix
    ./networking.nix
    ./boot.nix
    ./users.nix
  ];

  modules.niri.enable = true;

  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;

      dockerCompat = true;

      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
