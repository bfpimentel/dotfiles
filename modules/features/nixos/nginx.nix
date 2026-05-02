{ ... }:

let
  acmeHost = "local.jalotopimentel.com";
  mkProxyHost = port: {
    useACMEHost = acmeHost;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://10.22.4.6:${toString port}";
      proxyWebsockets = true;
    };
  };
in
{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, ... }:
      {
        security.acme = {
          acceptTerms = true;
          defaults.email = "hello@bruno.so";

          certs.${acmeHost} = {
            domain = "*.${acmeHost}";
            extraDomainNames = [ acmeHost ];
            dnsProvider = "cloudflare";
            group = "nginx";
            environmentFile = config.age.secrets.nginx-env.path;
          };
        };

        services.nginx = {
          enable = true;
          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;

          virtualHosts = {
            "bap.local.jalotopimentel.com" = mkProxyHost 6224;
            "drip.local.jalotopimentel.com" = mkProxyHost 7123;
            "photos.local.jalotopimentel.com" = mkProxyHost 2283;
            "torrent.local.jalotopimentel.com" = mkProxyHost 8080;
            "media.local.jalotopimentel.com" = mkProxyHost 8096;
            "satellite.local.jalotopimentel.com" = mkProxyHost 6333;
            "shady.local.jalotopimentel.com" = mkProxyHost 7112;
          };
        };

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
      }
    )
  ];
}
