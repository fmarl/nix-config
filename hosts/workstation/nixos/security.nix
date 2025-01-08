{ config, lib, modulesPath, pkgs, ... }:

with lib;

{
  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };

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
