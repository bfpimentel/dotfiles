{ domain }:

let
  mkDockerLabels =
    id: name: subdomain: port:
    let
      url = "${subdomain}.${domain}";
    in
    {
      # Traefik
      "traefik.enable" = "true";
      "traefik.http.routers.${id}.entrypoints" = "https";
      "traefik.http.routers.${id}.rule" = "Host(`${url}`)";
      "traefik.http.services.${id}.loadbalancer.server.port" = toString port;
      # Glance
      "glance.id" = id;
      "glance.icon" = "si:${id}";
      "glance.name" = name;
      "glance.url" = "https://${url}";
    };

  util = {
    inherit mkDockerLabels;
  };
in
util
