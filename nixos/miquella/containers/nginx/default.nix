{ vars, ... }:

{
  services.nginx.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "hello@bruno.so";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx.virtualHosts."vault.${vars.domain}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${vars.maleniaIp}:9010";
    };
  };
}
