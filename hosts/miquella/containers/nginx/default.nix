{ ... }:

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

  services.nginx.virtualHosts = {
    "jalotopimentel.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/referencia-madrinhas" = {
        proxyPass = "https://photos.app.goo.gl/8Byq8eUVuNXivPZAA";
      };
      locations."/referencia-padrinhos" = {
        proxyPass = "https://photos.app.goo.gl/UJejtmYJHG9tjvYs7";
      };
      locations."/" = {
        extraConfig = ''
          return 301 $scheme://loja.jalotopimentel.com$request_uri;
        '';
      };
    };
    "www.jalotopimentel.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        extraConfig = ''
          return 301 $scheme://loja.jalotopimentel.com$request_uri;
        '';
      };
    };
    "notify.external.luana.casa" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://malenia:9012";
        proxyWebsockets = true;
      };
    };
    "vault.external.luana.casa" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://malenia:9045";
        proxyWebsockets = true;
      };
    };
  };
}
