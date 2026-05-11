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
            "bap.${acmeHost}" = mkLocalProxyHost 6224;
            "dash.${acmeHost}" = mkLocalProxyHost 7112;
            "drip.${acmeHost}" = mkLocalProxyHost 7123;
            "logs.${acmeHost}" = mkLocalProxyHost 7113;
            "media.${acmeHost}" = mkLocalProxyHost 8096;
            "photos.${acmeHost}" = mkLocalProxyHost 2283;
            "satellite.${acmeHost}" = mkLocalProxyHost 6333;
            "search.${acmeHost}" = mkLocalProxyHost 7114;
            "torrent.${acmeHost}" = mkLocalProxyHost 8080;

            # Remote
            "home.${acmeHost}" = mkRemoteProxyHost "10.22.4.3:8123";
            "storage.${acmeHost}" = mkRemoteProxyHost "10.22.4.4:2000";
            "streaming.${acmeHost}" = mkRemoteProxyHost "10.22.4.10:47990";
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
