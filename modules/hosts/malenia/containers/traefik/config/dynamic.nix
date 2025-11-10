vars: {
  http = {
    routers = {
      ollama = {
        entryPoints = [
          "https"
          "http"
        ];
        rule = "Host(`ollama.${vars.domain}`)";
        middlewares = [ "https-redirect" ];
        tls = {
          certResolver = "cloudflare";
        };
        service = "ollama";
      };
      sunshine = {
        entryPoints = [
          "https"
          "http"
        ];
        rule = "Host(`streaming.${vars.domain}`)";
        middlewares = [ "https-redirect" ];
        tls = {
          certResolver = "cloudflare";
        };
        service = "sunshine";
      };
      glances = {
        entryPoints = [
          "https"
          "http"
        ];
        rule = "Host(`glances.${vars.domain}`)";
        middlewares = [ "https-redirect" ];
        tls = {
          certResolver = "cloudflare";
        };
        service = "glances";
      };
      unraid = {
        entryPoints = [
          "https"
          "http"
        ];
        rule = "Host(`storage.${vars.domain}`)";
        middlewares = [ "https-redirect" ];
        tls = {
          certResolver = "cloudflare";
        };
        service = "unraid";
      };
    };
    services = {
      ollama = {
        loadBalancer = {
          servers = [ { url = "http://${vars.maleniaIp}:11434"; } ];
          passHostHeader = true;
        };
      };
      sunshine = {
        loadBalancer = {
          servers = [ { url = "https://${vars.maleniaIp}:47990"; } ];
          passHostHeader = true;
        };
      };
      unraid = {
        loadBalancer = {
          servers = [ { url = "http://${vars.godwynIp}"; } ];
          passHostHeader = true;
        };
      };
    };
    middlewares = {
      securityHeaders = {
        headers = {
          customResponseHeaders = {
            X-Robots-Tag = "none,noarchive,nosnippet,notranslate,noimageindex";
            server = "";
            X-Forwarded-Proto = "https";
          };
          sslProxyHeaders = {
            X-Forwarded-Proto = "https";
          };
          referrerPolicy = "strict-origin-when-cross-origin";
          hostsProxyHeaders = [ "X-Forwarded-Host" ];
          customRequestHeaders = {
            X-Forwarded-Proto = "https";
          };
          contentTypeNosniff = true;
          browserXssFilter = true;
          forceSTSHeader = true;
          stsIncludeSubdomains = true;
          stsSeconds = 63072000;
          stsPreload = true;
        };
      };
      https-redirect = {
        redirectScheme = {
          scheme = "https";
        };
      };
      auth = {
        forwardauth = {
          address = "http://tinyauth:3000/api/auth/traefik";
          trustForwardHeader = true;
          authResponseHeaders = [
            "Authorization"
          ];
        };
      };
    };
  };
}
