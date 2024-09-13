{ vars, username, ... }:

let
  tautulliPath = "${vars.containersConfigRoot}/tautulli";

  directories = [ tautulliPath ];

  puid = toString vars.defaultUserUID;
  guid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers = {
    containers = {
      tautulli = {
        image = "ghcr.io/tautulli/tautulli";
        autoStart = true;
        volumes = [ "${tautulliPath}:/config" ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = guid;
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.tautulli.rule" = "Host(`tautulli.${vars.domain}`)";
          "traefik.http.routers.tautulli.entryPoints" = "https";
          "traefik.http.services.tautulli.loadbalancer.server.port" = "8181";
          # Homepage
          "homepage.group" = "Monitoring";
          "homepage.name" = "Tautulli";
          "homepage.icon" = "tautulli.svg";
          "homepage.href" = "https://tautulli.${vars.domain}";
        };
      };
    };
  };
}
