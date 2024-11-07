{ config, lib, modulesPath, pkgs, ... }:

with lib;

{
  imports =
    [
      (modulesPath + "/profiles/hardened.nix")
    ];

  environment.memoryAllocator.provider = mkForce "libc";
  environment.extraInit = "umask 0077";

  security = {
    sudo.execWheelOnly = true;

    protectKernelImage = mkDefault true;

    allowSimultaneousMultithreading = mkForce true;

    # This is required by podman to run containers in rootless mode.
    unprivilegedUsernsClone = mkDefault config.virtualisation.containers.enable;

    apparmor = {
      enable = mkDefault true;
      killUnconfinedConfinables = mkDefault true;
    };

    rtkit.enable = true;
    polkit.enable = true;
  };
}
