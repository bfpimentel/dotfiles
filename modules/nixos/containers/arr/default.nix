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

  puid = "1000"; # default user UID
  guid = "994"; # podman GID
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} podman - -") directories;

  virtualisation.oci-containers = {
    containers = {
      sonarr = {
        image = "lscr.io/linuxserver/sonarr:develop";
        autoStart = true;
        extraOptions = [
          "--pull=newer"
          "-l=traefik.enable=true"
          "-l=traefik.http.routers.sonarr.rule=Host(`sonarr.${vars.domain}`)"
          "-l=traefik.http.services.sonarr.loadbalancer.server.port=8989"
          # Homepage
          "-l=homepage.group=Media"
          "-l=homepage.name=Sonarr"
          "-l=homepage.icon=sonarr.svg"
          "-l=homepage.href=https://sonarr.${vars.domain}"
          "-l=homepage.widget.type=sonarr"
          "-l=homepage.widget.key={{HOMEPAGE_FILE_SONARR_KEY}}"
          "-l=homepage.widget.url=http://sonarr:8989"
        ];
        volumes = [
          "${vars.storageMountLocation}/downloads:/downloads"
          "${vars.storageMountLocation}/media/animes:/anime"
          "${vars.storageMountLocation}/media/shows:/shows"
          "${sonarrPath}:/config"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          GUID = guid;
          UMASK = "002";
        };
      };
      radarr = {
        image = "lscr.io/linuxserver/radarr:develop";
        autoStart = true;
        extraOptions = [
          "--pull=newer"
          "-l=traefik.enable=true"
          "-l=traefik.http.routers.radarr.rule=Host(`radarr.${vars.domain}`)"
          "-l=traefik.http.services.radarr.loadbalancer.server.port=7878"
          # Homepage
          "-l=homepage.group=Media"
          "-l=homepage.name=Radarr"
          "-l=homepage.icon=radarr.svg"
          "-l=homepage.href=https://radarr.${vars.domain}"
          "-l=homepage.widget.type=radarr"
          "-l=homepage.widget.key={{HOMEPAGE_FILE_RADARR_KEY}}"
          "-l=homepage.widget.url=http://radarr:7878"
        ];
        volumes = [
          "${vars.storageMountLocation}/downloads:/downloads"
          "${vars.storageMountLocation}/media/movies:/movies"
          "${radarrPath}:/config"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          GUID = guid;
          UMASK = "002";
        };
      };
      prowlarr = {
        image = "lscr.io/linuxserver/prowlarr:latest";
        autoStart = true;
        extraOptions = [
          "--pull=newer"
          "-l=traefik.enable=true"
          "-l=traefik.http.routers.prowlarr.rule=Host(`prowlarr.${vars.domain}`)"
          "-l=traefik.http.services.prowlarr.loadbalancer.server.port=9696"
          # Homepage
          "-l=homepage.group=Download Managers"
          "-l=homepage.name=Prowlarr"
          "-l=homepage.icon=prowlarr.svg"
          "-l=homepage.href=https://prowlarr.${vars.domain}"
        ];
        volumes = [ "${prowlarrPath}:/config" ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          GUID = guid;
          UMASK = "002";
        };
      };
      bazarr = {
        image = "lscr.io/linuxserver/bazarr:development";
        autoStart = true;
        extraOptions = [
          "--pull=newer"
          "-l=traefik.enable=true"
          "-l=traefik.http.routers.bazarr.rule=Host(`bazarr.${vars.domain}`)"
          "-l=traefik.http.services.bazarr.loadbalancer.server.port=6767"
          # Homepage
          "-l=homepage.group=Media"
          "-l=homepage.name=Bazarr"
          "-l=homepage.icon=bazarr.svg"
          "-l=homepage.href=https://bazarr.${vars.domain}"
          "-l=homepage.widget.type=bazarr"
          "-l=homepage.widget.key={{HOMEPAGE_FILE_BAZARR_KEY}}"
          "-l=homepage.widget.url=http://bazarr:6767"
        ];
        volumes = [ 
          "${bazarrPath}:/config" 
          "${vars.storageMountLocation}/media/shows:/downloads"
          "${vars.storageMountLocation}/media/movies:/movies"
          "${vars.storageMountLocation}/media/animes:/downloads"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          GUID = guid;
          UMASK = "002";
        };
      };
    };
  };
}
