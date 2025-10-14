{
  hostname,
  domain,
  lib,
}:

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

  absoluteHomeManagerPath = "/etc/nixos/modules/home-manager";

  linkHostApp =
    config: app:
    let
      hostPath = "${absoluteHomeManagerPath}/hosts/${hostname}";
    in
    {
      ".config/${app}".source = config.lib.file.mkOutOfStoreSymlink "${hostPath}/apps/${app}/config";
    };

  linkSharedApp =
    config: app:
    let
      sharedPath = "${absoluteHomeManagerPath}/shared";
    in
    {
      ".config/${app}".source = config.lib.file.mkOutOfStoreSymlink "${sharedPath}/apps/${app}/config";
    };

  util = {
    inherit mkDockerLabels linkHostApp linkSharedApp;
  };
in
util
