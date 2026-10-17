{ pkgs, ... }:
{
  modules.waybar.zfsPool = "rpool";

  home.packages = with pkgs; [
    dive
    podman-tui
    docker-compose
  ];
}
