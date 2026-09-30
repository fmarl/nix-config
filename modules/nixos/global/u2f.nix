{
  lib,
  pkgs,
  users,
  ...
}:
let
  mappings = lib.mapAttrsToList (name: u: "${name}:${u.u2fKeys}") (
    lib.filterAttrs (_: u: u ? u2fKeys) users
  );
in
{
  services = {
    pcscd.enable = true;

    udev.packages = with pkgs; [
      yubikey-personalization
      libu2f-host
    ];
  };

  security.pam = {
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
        authfile = pkgs.writeText "u2f-mappings" (lib.concatStringsSep "\n" mappings);
      };
    };
  };
}
