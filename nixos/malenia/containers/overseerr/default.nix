{ vars, username, ... }:

let
  overseerrPath = "${vars.containersConfigRoot}/overseerr";

  directories = [ overseerrPath ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers = {
    containers = {
      overseerr = {
        image = "sctx/overseerr:develop";
        autoStart = true;
        volumes = [ "${overseerrPath}:/app/config" ];
        environment = {
          TZ = vars.timeZone;
          PORT = "5055";
          LOG_LEVEL = "debug";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.overseerr.rule" = "Host(`request.${vars.domain}`)";
          "traefik.http.routers.overseerr.entryPoints" = "https";
          "traefik.http.services.overseerr.loadbalancer.server.port" = "5055";
          # Homepage
          "homepage.group" = "Misc";
          "homepage.name" = "Overseerr";
          "homepage.icon" = "overseerr.svg";
          "homepage.href" = "https://request.${vars.domain}";
        };
      };
    };
  };
}
