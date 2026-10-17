# NixOS
The configuration of my NixOS systems.

### Rebuilding
In the devshell (direnv loads it):
```
nh os switch .
nh home switch .
```

### Adding a host
```
nix run .#new-host -- <hostname> /dev/disk/by-id/<disk> [zfs|ext4|xfs]
```
This creates `hosts/<hostname>` with an SSH key encrypted into its `secrets.yaml`
and a [disko](https://github.com/nix-community/disko) disk layout.

### Installing
Build and boot the installer:
```
nix build .#installer
```
Then install from another host, with the disk passphrase in `./disk.key`:
```
nix run nixpkgs#nixos-anywhere -- --flake .#<hostname> \
    --generate-hardware-config nixos-facter hosts/<hostname>/nixos/facter.json \
    --disk-encryption-keys /tmp/secret.key ./disk.key \
    root@<address>
```
or locally on the installer, as described in its login message.
