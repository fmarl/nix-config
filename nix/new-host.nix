{ pkgs }:
pkgs.writeShellApplication {
  name = "new-host";
  runtimeInputs = with pkgs; [
    coreutils
    git
    openssh
    sops
  ];
  text = ''
    usage() {
        cat <<EOF
    Usage: nix run .#new-host -- HOSTNAME DISK [zfs|ext4|xfs]

    Create hosts/HOSTNAME with a new SSH key, encrypted into its secrets.yaml,
    and the disk layout for disko. Run it in the root of nix-config.

      DISK  Target disk, preferably /dev/disk/by-id/...
    EOF
    }

    if [[ $# -lt 2 || $# -gt 3 ]]; then
        usage >&2
        exit 1
    fi

    host=$1
    disk=$2
    layout=''${3:-zfs}
    dir="hosts/$host"

    [[ -f flake.nix && -d hosts ]] || { echo "Run this in the root of nix-config" >&2; exit 1; }
    [[ $host =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]] || { echo "Invalid hostname: $host" >&2; exit 1; }
    [[ $layout =~ ^(zfs|ext4|xfs)$ ]] || { echo "Unsupported layout: $layout" >&2; exit 1; }
    [[ ! -e $dir ]] || { echo "$dir already exists" >&2; exit 1; }

    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT

    mkdir -p "$dir/nixos" "$dir/home-manager"

    ssh-keygen -q -t ed25519 -N "" -C "$(id -un)@$host" -f "$tmp/ssh"
    cp "$tmp/ssh.pub" "$dir/ssh.pub"

    # Encrypted to the recipients of .sops.yaml, which only needs the public key
    {
        echo "ssh: |"
        sed 's/^/    /' "$tmp/ssh"
    } | sops encrypt --filename-override "$dir/secrets.yaml" \
        --input-type yaml --output-type yaml /dev/stdin >"$tmp/secrets.yaml"
    mv "$tmp/secrets.yaml" "$dir/secrets.yaml"

    cat >"$dir/shared.nix" <<EOF
    {
      machine.desktop = true;
    }
    EOF

    cat >"$dir/nixos/default.nix" <<EOF
    {
      # Written by nixos-anywhere --generate-hardware-config nixos-facter
      hardware.facter.reportPath = if builtins.pathExists ./facter.json then ./facter.json else null;

      modules.disko = {
        enable = true;
        device = "$disk";
        layout = "$layout";
      };
    }
    EOF

    echo "{ }" >"$dir/home-manager/default.nix"

    # Flakes only see files known to git
    git add --intent-to-add "$dir"

    cat <<EOF
    Created $dir. Next steps:

      1. Boot the installer (nix build .#installer) on the new machine.
      2. From this machine, with the disk passphrase in ./disk.key:
           nix run nixpkgs#nixos-anywhere -- --flake .#$host \\
               --generate-hardware-config nixos-facter $dir/nixos/facter.json \\
               --disk-encryption-keys /tmp/secret.key ./disk.key \\
               root@<address>
         Or locally on the installer, see its login message.
      3. Log in, clone nix-config to ~/src/nix-config and run: nh home switch
    EOF
  '';
}
