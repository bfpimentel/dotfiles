{
  vars,
  ...
}:

{
  security.acme = {
    acceptTerms = true;
    defaults.email = "hello@bruno.so";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;
    user = vars.defaultUser;
    virtualHosts = {
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
          return = "301 $scheme://loja.jalotopimentel.com$request_uri";
        };
      };
      "www.jalotopimentel.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          return = "301 $scheme://loja.jalotopimentel.com$request_uri";
        };
      };
    };
  };
}
