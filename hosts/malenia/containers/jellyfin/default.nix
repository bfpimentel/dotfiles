{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  jellyfinPaths =
    let
      root = "${vars.containersConfigRoot}/jellyfin";
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

  cfg = config.bfmp.containers.jellyfin;
in
{
  options.bfmp.containers.jellyfin = {
    enable = mkEnableOption "Enable Jellyfin";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues jellyfinPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      jellyfin = {
        image = "lscr.io/linuxserver/jellyfin:latest";
        autoStart = true;
        extraOptions = [ "--gpus=all" ];
        ports = [
          "7359:7359/udp"
          "1900:1900/udp"
        ];
        volumes = [
          "${jellyfinPaths.volumes.data}:/config"
          "${jellyfinPaths.mounts.media}:/media"
        ];
        environment = {
          PUID = puid;
          PGID = pgid;
          TZ = vars.timeZone;
          JELLYFIN_PublishedServerUrl = "https://media.${vars.domain}";
        };
        labels = util.mkDockerLabels {
          id = "jellyfin";
          name = "Jellyfin";
          subdomain = "media";
          port = 8096;
        };
      };
    };
  };
}
