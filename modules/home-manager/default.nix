{
  lib,
  pkgs,
  inputs,
  theme,
  ...
}:
{
  imports = [
    ../shared/machine.nix
    ./global
    ./desktop
    ./laptop.nix
    ./optional
  ];

  _module.args = {
    sandbox = import ./lib/sandbox.nix { inherit lib pkgs inputs; };
    bemenu = import ./lib/bemenu.nix { inherit lib pkgs theme; };
  };
}
