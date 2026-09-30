{ primaryUser, ... }:
{
  sops.age = {
    keyFile = "/home/${primaryUser}/.config/sops/age/keys.txt";
    generateKey = true;
  };
}
