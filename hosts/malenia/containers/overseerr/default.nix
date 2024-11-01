{ vars, username, ... }:

let
  overseerrPath = "${vars.containersConfigRoot}/overseerr";

  directories = [ overseerrPath ];

  puid = toString vars.defaultUserUID;
  guid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers.containers = {
    overseerr = {
      image = "lscr.io/linuxserver/overseerr:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      volumes = [ "${overseerrPath}:/config" ];
      environment = {
        TZ = vars.timeZone;
        PORT = "5055";
        LOG_LEVEL = "debug";
        PUID = puid;
        GUID = guid;
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
}
