{
  host,
  ...
}:
{
  services.mullvad-vpn.enable = true;

  networking = {
    hostName = host;

    nftables.enable = true;

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    timeServers = [
      "0.de.pool.ntp.org"
      "1.de.pool.ntp.org"
      "2.de.pool.ntp.org"
      "3.de.pool.ntp.org"
    ];
  };
}
