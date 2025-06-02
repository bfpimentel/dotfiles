{ domain, lib }:

let
  buildIconUrl = icon: "https://cdn.jsdelivr.net/gh/selfhst/icons/png/${icon}.png";

  mkDockerLabels =
    {
      id,
      name,
      subdomain,
      port,
      auth ? false,
      icon ? null,
      iconUrl ? null,
    }:
    let
      url = "${subdomain}.${domain}";
      actualIcon = if icon != null then icon else id;
      authLabel =
        if auth then
          {
            "traefik.http.routers.${id}.middlewares" = "auth@file";
          }
        else
          { };
    in
    {
      # Traefik
      "traefik.enable" = "true";
      "traefik.http.routers.${id}.entrypoints" = "https";
      "traefik.http.routers.${id}.rule" = "Host(`${url}`)";
      "traefik.http.services.${id}.loadbalancer.server.port" = toString port;
      # Glance
      "glance.id" = id;
      "glance.icon" = if iconUrl != null then iconUrl else (buildIconUrl actualIcon);
      "glance.name" = name;
      "glance.url" = "https://${url}";
    }
    // authLabel;

  util = {
    inherit mkDockerLabels;
  };
in
util
