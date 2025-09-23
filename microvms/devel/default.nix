{
  pkgs,
  ...
}:
{
  microvm = {
    hypervisor = "cloud-hypervisor";
    mem = 2048;
    vcpu = 2;
    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }
    ];
  };

  networking.hostName = "devel-microvm";
  system.stateVersion = pkgs.lib.trivial.release;

  services.getty.autologinUser = "user";
  users.users.user = {
    password = "";
    group = "user";
    isNormalUser = true;
  };
  users.groups.user = { };
  security.sudo.enable = false;

  environment.systemPackages = with pkgs; [
    git
  ];
}
