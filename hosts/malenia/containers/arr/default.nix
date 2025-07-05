{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  arrVars = import ./vars.nix;

  arrPaths = {
    volumes = {
      radarr = "${vars.containersConfigRoot}/radarr";
      sonarr = "${vars.containersConfigRoot}/sonarr";
      prowlarr = "${vars.containersConfigRoot}/prowlarr";
      bazarr = "${vars.containersConfigRoot}/bazarr";
    };
    mounts = {
      downloads = "${vars.mediaMountLocation}/downloads";
      movies = "${vars.mediaMountLocation}/movies";
      anime = "${vars.mediaMountLocation}/anime";
      shows = "${vars.mediaMountLocation}/shows";
    };
  };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;

  cfg = config.bfmp.containers.arr;
in
{
  options.bfmp.containers.arr = {
    enable = mkEnableOption "Enable Arr Stack: Sonarr, Radarr, Prowlarr, Bazarr and Flaresoverr";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues arrPaths.volumes
    );

    virtualisation.oci-containers.containers = with arrPaths; {
      radarr = {
        image = "lscr.io/linuxserver/radarr:develop";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [
          "${volumes.radarr}:/config"
          "${mounts.downloads}:/downloads"
          "${mounts.movies}:/movies"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          UMASK = "002";
        };
        labels =
          util.mkDockerLabels {
            id = "radarr";
            name = "Radarr";
            subdomain = "radarr";
            port = 7878;
            auth = true;
          }
          // {
            "tinyauth.basic.user" = arrVars.radarr.user;
            "tinyauth.basic.password" = arrVars.radarr.password;
          };
      };
      sonarr = {
        image = "lscr.io/linuxserver/sonarr:develop";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [
          "${volumes.sonarr}:/config"
          "${mounts.downloads}:/downloads"
          "${mounts.anime}:/anime"
          "${mounts.shows}:/shows"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          UMASK = "002";
        };
        labels =
          util.mkDockerLabels {
            id = "sonarr";
            name = "Sonarr";
            subdomain = "sonarr";
            port = 8989;
            auth = false;
          }
          // {
            "tinyauth.basic.user" = arrVars.sonarr.user;
            "tinyauth.basic.password" = arrVars.sonarr.password;
          };
      };
      bazarr = {
        image = "lscr.io/linuxserver/bazarr:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [
          "${volumes.bazarr}:/config"
          "${mounts.movies}:/movies"
          "${mounts.anime}:/anime"
          "${mounts.shows}:/shows"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          UMASK = "002";
        };
        labels =
          util.mkDockerLabels {
            id = "bazarr";
            name = "Bazarr";
            subdomain = "bazarr";
            port = 6767;
            auth = false;
          }
          // {
            "tinyauth.basic.user" = arrVars.bazarr.user;
            "tinyauth.basic.password" = arrVars.bazarr.password;
          };
      };
      prowlarr = {
        image = "lscr.io/linuxserver/prowlarr:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [ "${volumes.prowlarr}:/config" ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          UMASK = "002";
        };
        labels =
          util.mkDockerLabels {
            id = "prowlarr";
            name = "Prowlarr";
            subdomain = "prowlarr";
            port = 9696;
            auth = false;
          }
          // {
            "tinyauth.basic.user" = arrVars.prowlarr.user;
            "tinyauth.basic.password" = arrVars.prowlarr.password;
          };
      };
      flaresolverr = {
        image = "ghcr.io/flaresolverr/flaresolverr:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        environment = {
          TZ = vars.timeZone;
          LOG_LEVEL = "info";
          LOG_HTML = "false";
        };
        labels = util.mkDockerLabels {
          id = "flaresolverr";
          name = "Flaresolverr";
          subdomain = "flaresolverr";
          port = 8191;
          auth = false;
        };
      };
    };
  };
}
