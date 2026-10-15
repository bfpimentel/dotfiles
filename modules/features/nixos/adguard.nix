{ ... }:

let
  adguardAddress = "10.22.4.7";
in
{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { ... }:
      {
        services.adguardhome = {
          enable = true;
          settings = {
            http.address = "${adguardAddress}:3000";
            dns = {
              bind_hosts = [ adguardAddress ];
              port = 53;

              upstream_dns = [
                "https://dns.cloudflare.com/dns-query"
                "https://dns.google/dns-query"
              ];

              bootstrap_dns = [
                "1.1.1.1"
                "8.8.8.8"
              ];
            };
          };
        };

        networking.firewall = {
          allowedTCPPorts = [
            53
            3000
          ];
          allowedUDPPorts = [ 53 ];
        };
      }
    )
  ];
}
