{ vars, ... }:

{
  api = {
    dashboard = true;
    debug = true;
    insecure = true;
  };

  entrypoints = {
    http = {
      address = ":80";
      http = {
        redirections = {
          entrypoints = {
            to = "https";
            scheme = "https";
          };
        };
      };
    };
    https = {
      address = ":443";
      http = {
        tls = {
          certResolver = "cloudflare";
          domains = [
            {
              main = vars.domain;
              sans = [ "*.${vars.domain}" ];
            }
          ];
        };
        middlewares = [ "securityHeaders@file" ];
      };
    };
  };

  serversTransport = {
    includeSkipVerify = true;
  };

  providers = {
    providersThrottleDuration = "2s";
    docker = {
      network = "podman0";
      endpoint = "unix:///var/run/docker.sock";
      exposedByDefault = false;
    };
    file = {
      filename = "/dynamic.yml";
      watch = true;
    };
  };

  certificateResolvers = {
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
