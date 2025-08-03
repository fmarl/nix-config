{
  networking = {
    firewall = {
      enable = false;
      trustedInterfaces = [
        "virbr0"
      ];
    };

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
