{ config, lib, pkgs, modulesPath, ... }:

with lib;

{
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

    pam = {
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
      
      u2f = {
        enable = true;
        settings = {
          interactive = true;
          cue = true;

          origin = "pam://yubi";
          authfile = pkgs.writeText "u2f-mappings" (lib.concatStrings [
            "marrero:NYkhoS5+8SwGfd6s2+kNDB6lUHYOsEG73xRqaM0qYP4YHZSs7YzMdlMPqfhVlSF5yoiQiicHbxpWzHVwpwtkRA==,xdBNy40OgdldkNuoh42OrS6YwohCSSW4gjqX7NkKqqDxfS2qhws3XAGd3mJfaLUJ9tDwrM7LaPo0y+XDKljrDg==,es256,+presence"
          ]);
        };
      };
    };
  };
}
