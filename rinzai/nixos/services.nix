{ config, pkgs, lib, ... }:
{
  services = {
    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };

    kubernetes = {
      roles = [ "master" "node" ];
      masterAddress = "rinzai";
      apiserverAddress = "https://rinzai:6443";
      easyCerts = true;
      apiserver = {
        securePort = 6443;
        advertiseAddress = "192.168.0.2";
      };

      # use coredns
      addons.dns.enable = true;

      # needed if you use swap
      kubelet.extraOpts = "--fail-swap-on=false";
    };

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
      hostKeys =
        [
          {
            path = "/persist/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
          {
            path = "/persist/etc/ssh/ssh_host_rsa_key";
            type = "rsa";
            bits = 4096;
          }
        ];
    };
  };

  systemd = {
    coredump.enable = false;
  };
}
