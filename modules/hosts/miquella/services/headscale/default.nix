{ vars, config, ... }:

{
  environment.systemPackages = [ config.services.headscale.package ];

  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 8085;
    user = vars.defaultUser;

    settings = {
      server_url = "https://vpn.${vars.externalDomain}";
      ip_prefixes = [ "10.22.10.0/10" ];
      dns = {
        magic_dns = true;
        nameservers.global = [ "1.1.1.1" "8.8.8.8" ];
        base_domain = "tail.${vars.externalDomain}";
      };
    };
  };

  services.nginx.virtualHosts."vpn.${vars.externalDomain}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.headscale.port}";
      proxyWebsockets = true;
    };
  };
}
