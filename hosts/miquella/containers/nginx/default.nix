{
  username,
  config,
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
    user = username;
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
        basicAuthFile = config.age.secrets.nginx-vault.path;
        locations."/admin" = {
          proxyPass = "http://malenia:9045/admin";
          extraConfig = ''
            auth_basic "Admin";
          '';
        };
        locations."/" = {
          proxyPass = "http://malenia:9045";
          proxyWebsockets = true;
          extraConfig = ''
            auth_basic off;
          '';
        };
      };
      "baikal.external.luana.casa" = {
        forceSSL = true;
        enableACME = true;
        basicAuthFile = config.age.secrets.nginx-baikal.path;
        locations."/admin" = {
          proxyPass = "http://malenia:9040/admin";
          proxyWebsockets = true;
          extraConfig = ''
            auth_basic "Admin";
            proxy_set_header Host $host:$server_port;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
        locations."/" = {
          proxyPass = "http://malenia:9040";
          proxyWebsockets = true;
          extraConfig = ''
            auth_basic off;
            proxy_set_header Host $host:$server_port;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };
}
