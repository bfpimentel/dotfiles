{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  tautulliPaths =
    let
      root = "${vars.containersConfigRoot}/tautulli";
    in
    {
      volumes = {
        inherit root;
      };
    };

  puid = toString vars.defaultUserUID;
  guid = toString vars.defaultUserGID;

  cfg = config.bfmp.containers.tautulli;
in
{
  options.bfmp.containers.tautulli = {
    enable = mkEnableOption "Enable Tautulli";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues tautulliPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      tautulli = {
        image = "ghcr.io/tautulli/tautulli";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [ "${tautulliPaths.volumes.root}:/config" ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = guid;
        };
        labels = util.mkDockerLabels {
          id = "tautulli";
          name = "Tautulli";
          subdomain = "tautulli";
          port = 8181;
        };
      };
    };
  };
}
