{ vars, username, ... }:

let
  sonarrPath = "${vars.containersConfigRoot}/sonarr";
  radarrPath = "${vars.containersConfigRoot}/radarr";
  prowlarrPath = "${vars.containersConfigRoot}/prowlarr";
  bazarrPath = "${vars.containersConfigRoot}/bazarr";

  directories = [
    sonarrPath
    radarrPath
    prowlarrPath
    bazarrPath
  ];

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers = {
    containers = {
      sonarr = {
        image = "lscr.io/linuxserver/sonarr:develop";
        autoStart = true;
        volumes = [
          "${sonarrPath}:/config"
          "${vars.mediaMountLocation}/downloads:/downloads"
          "${vars.mediaMountLocation}/anime:/anime"
          "${vars.mediaMountLocation}/shows:/shows"
        ];
        extraOptions = [ "--pull=newer" ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          UMASK = "002";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.sonarr.rule" = "Host(`sonarr.${vars.domain}`)";
          "traefik.http.services.sonarr.loadbalancer.server.port" = "8989";
          # Homepage
          "homepage.group" = "Media";
          "homepage.name" = "Sonarr";
          "homepage.icon" = "sonarr.svg";
          "homepage.href" = "https://sonarr.${vars.domain}";
          "homepage.weight" = "10";
          "homepage.widget.type" = "sonarr";
          "homepage.widget.key" = "{{HOMEPAGE_VAR_SONARR_KEY}}";
          "homepage.widget.url" = "http://sonarr:8989";
        };
      };
      radarr = {
        image = "lscr.io/linuxserver/radarr:develop";
        autoStart = true;
        volumes = [
          "${radarrPath}:/config"
          "${vars.mediaMountLocation}/downloads:/downloads"
          "${vars.mediaMountLocation}/movies:/movies"
        ];
        extraOptions = [ "--pull=newer" ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          UMASK = "002";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.radarr.rule" = "Host(`radarr.${vars.domain}`)";
          "traefik.http.services.radarr.loadbalancer.server.port" = "7878";
          # Homepage
          "homepage.group" = "Media";
          "homepage.name" = "Radarr";
          "homepage.icon" = "radarr.svg";
          "homepage.href" = "https://radarr.${vars.domain}";
          "homepage.weight" = "20";
          "homepage.widget.type" = "radarr";
          "homepage.widget.key" = "{{HOMEPAGE_VAR_RADARR_KEY}}";
          "homepage.widget.url" = "http://radarr:7878";
        };
      };
      bazarr = {
        image = "lscr.io/linuxserver/bazarr:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [
          "${bazarrPath}:/config"
          "${vars.mediaMountLocation}/movies:/movies"
          "${vars.mediaMountLocation}/anime:/anime"
          "${vars.mediaMountLocation}/shows:/shows"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          UMASK = "002";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.bazarr.rule" = "Host(`bazarr.${vars.domain}`)";
          "traefik.http.services.bazarr.loadbalancer.server.port" = "6767";
          # Homepage
          "homepage.group" = "Media";
          "homepage.name" = "Bazarr";
          "homepage.icon" = "bazarr.svg";
          "homepage.href" = "https://bazarr.${vars.domain}";
          "homepage.weight" = "30";
          "homepage.widget.type" = "bazarr";
          "homepage.widget.key" = "{{HOMEPAGE_VAR_BAZARR_KEY}}";
          "homepage.widget.url" = "http://bazarr:6767";
        };
      };
      prowlarr = {
        image = "lscr.io/linuxserver/prowlarr:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [ "${prowlarrPath}:/config" ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          UMASK = "002";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.prowlarr.rule" = "Host(`prowlarr.${vars.domain}`)";
          "traefik.http.services.prowlarr.loadbalancer.server.port" = "9696";
          # Homepage
          "homepage.group" = "Download Managers";
          "homepage.name" = "Prowlarr";
          "homepage.icon" = "prowlarr.svg";
          "homepage.href" = "https://prowlarr.${vars.domain}";
        };
      };
      flaresolverr = {
        image = "ghcr.io/flaresolverr/flaresolverr:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        environment = {
          TZ = vars.timeZone;
          LOG_LEVEL = "info";
          LOG_HTML = "false";
        };
      };
    };
  };
}
