{ config, lib, pkgs, ... }:

with lib;

{
  security = {
    protectKernelImage = mkDefault true;

    allowSimultaneousMultithreading = mkDefault true;

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
