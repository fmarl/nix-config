{
  config,
  self,
  host,
  ...
}:
{
  sops = {
    age = {
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      generateKey = true;
    };

    defaultSopsFile = "${self}/hosts/${host}/secrets.yaml";

    secrets.ssh.path = "/run/user/1000/secrets/ssh";
  };
}
