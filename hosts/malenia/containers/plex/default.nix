{
  config,
  lib,
  vars,
  ...
}:

with lib;
let
  plexPaths =
    let
      root = "${vars.containersConfigRoot}/plex";
    in
    {
      volumes = {
        inherit root;
        data = "${root}/data";
      };
      mounts = {
        media = vars.mediaMountLocation;
      };
    };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;

  cfg = config.bfmp.containers.plex;
in
{
  options.bfmp.containers.plex = {
    enable = mkEnableOption "Enable Plex";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues plexPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      plex = {
        image = "lscr.io/linuxserver/plex:latest";
        autoStart = true;
        extraOptions = [ "--gpus=all" ];
        volumes = [
          "${plexPaths.volumes.data}:/config"
          "${plexPaths.mounts.media}:/media"
        ];
        environmentFiles = [ config.age.secrets.plex.path ];
        environment = {
          PUID = puid;
          PGID = pgid;
          TZ = vars.timeZone;
          VERSION = "docker";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.plex.entrypoints" = "https";
          "traefik.http.routers.plex.rule" = "Host(`media.${vars.domain}`)";
          "traefik.http.services.plex.loadbalancer.server.port" = "32400";
          # Homepage
          "homepage.group" = "Media";
          "homepage.name" = "Plex";
          "homepage.icon" = "sh-plex.svg";
          "homepage.href" = "https://media.${vars.domain}";
          "homepage.weight" = "6";
          "homepage.widget.type" = "tautulli";
          "homepage.widget.key" = "{{HOMEPAGE_VAR_PLEX_KEY}}";
          "homepage.widget.url" = "http://tautulli:8181";
          "homepage.widget.enableUser" = "true";
        };
      };
    };
  };
}
