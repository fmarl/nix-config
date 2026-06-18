{
  users,
  lib,
  ...
}:
let
  primaryUser = lib.head (lib.attrNames users);
in
{
  sops.age = {
    keyFile = "/home/${primaryUser}/.config/sops/age/keys.txt";
    generateKey = true;
  };
}
