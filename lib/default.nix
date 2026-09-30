{
  inputs,
  self,
  pkgs,
  lib,
  system,
}:
let
  users = import ./users.nix;

  primaryUsers = lib.attrNames (lib.filterAttrs (_: u: u.primary or false) users);
  primaryUser =
    assert lib.assertMsg (
      lib.length primaryUsers == 1
    ) "lib/users.nix must mark exactly one user as primary";
    lib.head primaryUsers;

  flib = {
    importDir = import ./import-dir.nix { inherit lib; };
  };

  hosts = lib.attrNames (lib.filterAttrs (_: t: t == "directory") (builtins.readDir ../hosts));

  mkSystem =
    host:
    lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        inherit
          inputs
          self
          host
          users
          primaryUser
          flib
          ;
      };
      modules = [
        ../modules/nixos
        ../hosts/${host}/nixos
        inputs.sops-nix.nixosModules.sops
      ];
    };

  mkHome =
    host: user:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit
          inputs
          self
          host
          user
          users
          flib
          ;
      };
      modules = [
        ../modules/home-manager
        ../hosts/${host}/home-manager
        inputs.sops-nix.homeManagerModules.sops
      ];
    };

  homePairs = lib.concatMap (
    host: map (user: lib.nameValuePair "${user}@${host}" (mkHome host user)) (lib.attrNames users)
  ) hosts;
in
{
  nixosConfigurations = lib.genAttrs hosts mkSystem;
  homeConfigurations = lib.listToAttrs homePairs;
}
