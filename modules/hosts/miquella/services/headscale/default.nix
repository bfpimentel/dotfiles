{ vars, config, ... }:

{
  environment.systemPackages = [ config.services.headscale.package ];

  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 8085;

    settings = {
      server_url = "https://vpn.${vars.domain}";
      ip_prefixes = [ "10.22.10.0/10" ];
      dns = {
        magic_dns = true;
        nameservers.global = [ "9.9.9.9" ];
        base_domain = "tail.${vars.domain}";
      };
    };
  };

  services.nginx.virtualHosts."vpn.${vars.domain}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.headscale.port}";
      proxyWebsockets = true;
    };
  };
}
