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
}
