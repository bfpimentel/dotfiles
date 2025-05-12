{
  config,
  lib,
  vars,
  util,
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
          VERSION = "latest";
        };
        labels = util.mkDockerLabels {
          id = "plex";
          name = "Plex";
          subdomain = "media";
          port = 32400;
        };
      };
    };
  };
}
