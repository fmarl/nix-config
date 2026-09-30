{ primaryUser, ... }:
{
  users.users.${primaryUser}.extraGroups = [
    "wireshark"
    "libvirtd"
    "podman"
  ];
}
