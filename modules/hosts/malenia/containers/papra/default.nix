{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  papraPaths =
    let
      root = "${vars.containersConfigRoot}/papra";
    in
    {
      volumes = {
        inherit root;
        data = "${root}/data";
      };
      mounts = {
        documents = vars.documentsMountLocation;
      };
    };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;

  cfg = config.bfmp.containers.papra;
in
{
  options.bfmp.containers.papra = {
    enable = mkEnableOption "Enable Papra";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues papraPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      papra = {
        image = "ghcr.io/papra-hq/papra:latest-rootless";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        user = "${puid}:${pgid}";
        networks = [ "local" ];
        volumes = [
          "${papraPaths.volumes.data}:/app/app-data"
          "${papraPaths.mounts.documents}:/documents"
        ];
        environmentFiles = [ config.age.secrets.papra.path ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
        };
        labels = util.mkDockerLabels {
          id = "papra";
          name = "Papra";
          subdomain = "docs";
          port = 1221;
        };
      };
    };
  };
}
