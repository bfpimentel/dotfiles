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
      media = {
        entryPoints = [
          "https"
          "http"
        ];
        rule = "Host(`media.${vars.domain}`)";
        middlewares = [ "https-redirect" ];
        tls = {
          certResolver = "cloudflare";
        };
        service = "media";
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
      glances = {
        loadBalancer = {
          servers = [ { url = "http://${vars.maleniaIp}:61208"; } ];
          passHostHeader = true;
        };
      };
      media = {
        loadBalancer = {
          servers = [ { url = "http://${vars.maleniaIp}:32400"; } ];
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
          address = "http://authentik-server:9000/outpost.goauthentik.io/auth/traefik";
          trustForwardHeader = true;
          authResponseHeaders = [
            "X-authentik-username"
            "X-authentik-groups"
            "X-authentik-email"
            "X-authentik-name"
            "X-authentik-uid"
            "X-authentik-jwt"
            "X-authentik-meta-jwks"
            "X-authentik-meta-outposts"
            "X-authentik-meta-provider"
            "X-authentik-meta-app"
            "X-authentik-meta-version"
            "authorization"
          ];
        };
      };
    };
  };
}
