{
  inputs,
  self,
  pkgs,
  lib,
  system,
}:
let
  users = import ./users.nix;

  hosts = lib.attrNames (
    lib.filterAttrs (_: t: t == "directory") (builtins.readDir ../hosts)
  );

  mkSystem =
    host:
    lib.nixosSystem {
      inherit system pkgs;
      specialArgs = { inherit inputs self host users; };
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
        inherit inputs self host user users;
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
