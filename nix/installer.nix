{
  nixpkgs,
  self,
  system,
}:
let
  installer = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      (
        { lib, pkgs, ... }:
        {
          isoImage.edition = lib.mkForce "fx";

          nixpkgs.config.allowUnfree = true;
          hardware.enableRedistributableFirmware = true;

          boot.supportedFilesystems.zfs = true;

          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

          console.keyMap = "us-acentos";

          # Snapshot of this repo; copy it somewhere writable before running bootstrap.sh
          environment.etc."nix-config".source = self;

          environment.systemPackages = with pkgs; [
            git
            curl
            parted
            dosfstools
            e2fsprogs
            xfsprogs
            cryptsetup
          ];

          users.motd = ''
            Install NixOS from fx's nix-config:

              cp -rT /etc/nix-config ~/nix-config && chmod -R u+w ~/nix-config
              sudo ~/nix-config/scripts/bootstrap.sh <disk> <zfs|ext4|xfs> <host>
          '';
        }
      )
    ];
  };
in
installer.config.system.build.isoImage
