{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  jellyseerrPaths =
    let
      root = "${vars.containersConfigRoot}/jellyseerr";
    in
    {
      volumes = {
        inherit root;
      };
    };

  cfg = config.bfmp.containers.jellyseerr;
in
{
  options.bfmp.containers.jellyseerr = {
    enable = mkEnableOption "Enable Jellyseerr";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues jellyseerrPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      jellyseerr = {
        image = "fallenbagel/jellyseerr:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [ "${jellyseerrPaths.volumes.root}:/app/config" ];
        environment = {
          TZ = vars.timeZone;
          LOG_LEVEL = "debug";
        };
        labels = util.mkDockerLabels {
          id = "jellyseerr";
          name = "Jellyseerr";
          subdomain = "request";
          port = 5055;
        };
      };
    };
  };
}
