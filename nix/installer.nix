{
  nixpkgs,
  self,
  system,
  hosts,
}:
let
  inherit (nixpkgs) lib;

  # The hosts of this flake may log in as root, e.g. for nixos-anywhere
  hostKeys = lib.filter builtins.pathExists (map (host: ../hosts/${host}/ssh.pub) hosts);

  installer = lib.nixosSystem {
    inherit system;
    modules = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      (
        { pkgs, ... }:
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

          users.users.root.openssh.authorizedKeys.keyFiles = hostKeys;

          # Snapshot of this repo; copy it somewhere writable before installing
          environment.etc."nix-config".source = self;

          environment.systemPackages = with pkgs; [
            git
            disko
            nixos-facter
          ];

          users.motd = ''
            Install a host of fx's nix-config, remotely from another host:

              nix run nixpkgs#nixos-anywhere -- --flake .#<host> ... root@<this machine>

            or locally:

              cp -rT /etc/nix-config ~/nix-config && chmod -R u+w ~/nix-config && cd ~/nix-config
              nixos-facter -o hosts/<host>/nixos/facter.json
              (umask 077; read -rs -p "Disk passphrase: " p && printf %s "$p" >/tmp/secret.key)
              disko-install --flake .#<host> --disk main <disk>

            Commit facter.json afterwards.
          '';
        }
      )
    ];
  };
in
installer.config.system.build.isoImage
