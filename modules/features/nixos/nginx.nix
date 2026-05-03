{ ... }:

let
  acmeHost = "local.jalotopimentel.com";

  mkLocalProxyHost = port: {
    useACMEHost = acmeHost;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://10.22.4.6:${toString port}";
      proxyWebsockets = true;
    };
  };

  mkRemoteProxyHost = address: {
    useACMEHost = acmeHost;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://${address}";
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
            # Local
            "bap.local.jalotopimentel.com" = mkLocalProxyHost 6224;
            "drip.local.jalotopimentel.com" = mkLocalProxyHost 7123;
            "photos.local.jalotopimentel.com" = mkLocalProxyHost 2283;
            "torrent.local.jalotopimentel.com" = mkLocalProxyHost 8080;
            "media.local.jalotopimentel.com" = mkLocalProxyHost 8096;
            "satellite.local.jalotopimentel.com" = mkLocalProxyHost 6333;
            "shady.local.jalotopimentel.com" = mkLocalProxyHost 7112;

            # Remote
            "storage.local.jalotopimentel.com" = mkRemoteProxyHost "10.22.4.4:2000";
            "home.local.jalotopimentel.com" = mkRemoteProxyHost "10.22.4.3:8123";
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
