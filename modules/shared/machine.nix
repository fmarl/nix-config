# Properties of a host, set in hosts/<host>/shared.nix. Imported by NixOS and
# home-manager alike, so both sides agree on them.
{
  config,
  lib,
  flib,
  ...
}:
let
  cfg = config.machine;
in
{
  options.machine = {
    theme = lib.mkOption {
      type = lib.types.enum flib.themes.names;
      default = "ef-owl";
    };

    desktop = lib.mkEnableOption "the niri desktop";

    laptop = lib.mkEnableOption "battery and power management";
  };

  config._module.args.theme = flib.themes.mk cfg.theme;
}
