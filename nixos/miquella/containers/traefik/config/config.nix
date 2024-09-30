domain: {
  api = {
    dashboard = true;
    debug = true;
    insecure = true;
  };

  entryPoints = {
    http = {
      address = ":80";
      forwardedHeaders = {
        trustedIPs = [
          "173.245.48.0/20"
          "103.21.244.0/22"
          "103.22.200.0/22"
          "103.31.4.0/22"
          "141.101.64.0/18"
          "108.162.192.0/18"
          "190.93.240.0/20"
          "188.114.96.0/20"
          "197.234.240.0/22"
          "198.41.128.0/17"
          "162.158.0.0/15"
          "104.16.0.0/12"
          "172.64.0.0/13"
          "131.0.72.0/22"
          "2400:cb00::/32"
          "2606:4700::/32"
          "2803:f800::/32"
          "2405:b500::/32"
          "2405:8100::/32"
          "2a06:98c0::/29"
          "2c0f:f248::/32"
        ];
      };
      http = {
        redirections = {
          entryPoint = {
            to = "https";
            scheme = "https";
          };
        };
      };
    };
    https = {
      address = ":443";
      forwardedHeaders = {
        trustedIPs = [
          "173.245.48.0/20"
          "103.21.244.0/22"
          "103.22.200.0/22"
          "103.31.4.0/22"
          "141.101.64.0/18"
          "108.162.192.0/18"
          "190.93.240.0/20"
          "188.114.96.0/20"
          "197.234.240.0/22"
          "198.41.128.0/17"
          "162.158.0.0/15"
          "104.16.0.0/12"
          "172.64.0.0/13"
          "131.0.72.0/22"
          "2400:cb00::/32"
          "2606:4700::/32"
          "2803:f800::/32"
          "2405:b500::/32"
          "2405:8100::/32"
          "2a06:98c0::/29"
          "2c0f:f248::/32"
        ];
      };
      http = {
        tls = {
          certResolver = "cloudflare";
          domains = [
            {
              main = domain;
              sans = [ "*.${domain}" ];
            }
            {
              main = "jalotopimentel.com";
              sans = [ "*.jalotopimentel.com" ];
            }
          ];
        };
        middlewares = [ "securityHeaders@file" ];
      };
    };
  };

  serversTransport = {
    insecureSkipVerify = true;
  };

  providers = {
    providersThrottleDuration = "2s";
    docker = {
      network = "podman";
      endpoint = "unix:///var/run/docker.sock";
      exposedByDefault = false;
    };
    file = {
      filename = "/dynamic.yml";
      watch = true;
    };
  };

  certificatesResolvers = {
    cloudflare = {
      acme = {
        email = "hello@bruno.so";
        storage = "acme.json";
        dnsChallenge = {
          provider = "cloudflare";
          disablePropagationCheck = false;
          resolvers = [
            "1.1.1.1:53"
            "1.0.0.1:53"
          ];
        };
      };
    };
  };
}
