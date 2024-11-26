{ vars, hostname, ... }:

{
  networking = {
    hostName = "${hostname}";
    defaultGateway = vars.defaultGateway;
    enableIPv6 = false;
    useDHCP = false;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    interfaces = {
      "${vars.networkInterface}".ipv4.addresses = [
        {
          address = vars.ip;
          prefixLength = 24;
        }
      ];
    };
    firewall = {
      enable = true;
      allowPing = true;
      pingLimit = "--limit 1/minute --limit-burst 5";
      trustedInterfaces = [
        vars.networkInterface
        "podman0"
      ];
      checkReversePath = false;
    };
  };
}
