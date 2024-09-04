{ hostname, vars, ... }:

{
  networking = {
    hostName = "${hostname}";
    defaultGateway = "10.22.4.1";
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
      trustedInterfaces = [
        vars.networkInterface
        "podman0"
      ];
      checkReversePath = false;
    };
  };
}
