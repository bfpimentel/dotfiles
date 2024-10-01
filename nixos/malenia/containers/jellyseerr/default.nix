{ vars, username, ... }:

let
  jellyseerrPath = "${vars.containersConfigRoot}/jellyseerr";

  directories = [ jellyseerrPath ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers.containers = {
    jellyseerr = {
      image = "fallenbagel/jellyseerr:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      volumes = [ "${jellyseerrPath}:/app/config" ];
      environment = {
        TZ = vars.timeZone;
        PORT = "5055";
        LOG_LEVEL = "debug";
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.jellyseerr.rule" = "Host(`request.${vars.domain}`)";
        "traefik.http.routers.jellyseerr.entryPoints" = "https";
        "traefik.http.services.jellyseerr.loadbalancer.server.port" = "5055";
        # Homepage
        "homepage.group" = "Misc";
        "homepage.name" = "Jellyseerr";
        "homepage.icon" = "jellyseerr.svg";
        "homepage.href" = "https://request.${vars.domain}";
      };
    };
  };
}
