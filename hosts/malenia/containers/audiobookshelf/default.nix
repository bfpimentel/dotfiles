{
  config,
  lib,
  vars,
util,
  ...
}:

with lib;
let
  audiobookshelfPaths =
    let
      root = "${vars.containersConfigRoot}/audiobookshelf";
    in
    {
      volumes = {
        inherit root;
        config = "${root}/config";
        metadata = "${root}/metadata";
      };
      mounts = {
        audiobooks = "${vars.mediaMountLocation}/audiobooks";
        podcasts = "${vars.mediaMountLocation}/podcasts";
      };
    };

  cfg = config.bfmp.containers.audiobookshelf;
in
{
  options.bfmp.containers.audiobookshelf = {
    enable = mkEnableOption "Enable Audiobookshelf";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues audiobookshelfPaths.volumes
    );

    virtualisation.oci-containers.containers = with audiobookshelfPaths; {
      audiobookshelf = {
        image = "ghcr.io/advplyr/audiobookshelf:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [
          "${volumes.config}:/config"
          "${volumes.metadata}:/metadata"
          "${mounts.audiobooks}:/audiobooks"
          "${mounts.podcasts}:/podcasts"
        ];
        environment = {
          TZ = vars.timeZone;
        };
        labels = util.mkDockerLabels {
          id = "audiobookshelf";
          name = "Audio Bookshelf";
          subdomain = "audiobooks";
          port = 80;
        };
      };
    };
  };
}
