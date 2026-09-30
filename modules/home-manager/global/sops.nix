{
  config,
  host,
  user,
  users,
  ...
}:
{
  sops = {
    age = {
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      generateKey = true;
    };

    defaultSopsFile = ../../../hosts + "/${host}/secrets.yaml";

    secrets.ssh.path = "/run/user/${toString users.${user}.uid}/secrets/ssh";
  };
}
