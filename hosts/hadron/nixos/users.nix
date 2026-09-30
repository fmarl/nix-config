{ primaryUser, ... }:
{
  users.users.${primaryUser} = {
    extraGroups = [ "kvm" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII5wD+zMGIVaENIRRxTwK0w+mqWfpeABf4JIp0zA7Vs3 marrero@ntb"
    ];
  };
}
