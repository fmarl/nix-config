{
  config,
  lib,
  host,
  ...
}:
let
  cfg = config.modules.firewall;
in
{
  options.modules.firewall = {
    lanSubnet = lib.mkOption {
      type = lib.types.str;
      default = "192.168.0.0/24";
    };

    lanTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [ ];
      description = "TCP ports open to the LAN only";
    };
  };

  config = {
    services = {
      mullvad-vpn.enable = true;

      resolved = {
        enable = true;
        settings.Resolve = {
          DNSOverTLS = "true";
          # Route every query to the servers above, never to ones learned via DHCP
          Domains = [ "~." ];
          FallbackDNS = [ ];
        };
      };
    };

    networking = {
      hostName = host;

      # ZFS needs a unique hostId. Existing hosts keep the one they were
      # installed with, new ones derive it from the hostname.
      hostId = lib.mkDefault (builtins.substring 0 8 (builtins.hashString "sha256" host));

      nftables.enable = true;

      nameservers = [
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
        "194.242.2.2#dns.mullvad.net"
      ];

      # Keep DHCP-provided resolvers out of resolved
      networkmanager.dns = lib.mkForce "none";

      firewall = {
        allowPing = false;

        extraInputRules = lib.mkMerge [
          ''
            ip saddr ${cfg.lanSubnet} icmp type echo-request limit rate 10/second accept
          ''
          (lib.mkIf (cfg.lanTCPPorts != [ ]) ''
            ip saddr ${cfg.lanSubnet} tcp dport { ${
              lib.concatMapStringsSep ", " toString cfg.lanTCPPorts
            } } accept
          '')
          # Within the LAN, refuse instead of timing out. Last, after the
          # rules other modules add.
          (lib.mkAfter ''
            ip saddr ${cfg.lanSubnet} reject with icmpx type port-unreachable
          '')
        ];
      };

      timeServers = [
        "0.de.pool.ntp.org"
        "1.de.pool.ntp.org"
        "2.de.pool.ntp.org"
        "3.de.pool.ntp.org"
      ];
    };
  };
}
