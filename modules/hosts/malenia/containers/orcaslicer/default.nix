{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  orcaslicerPaths =
    let
      root = "${vars.containersConfigRoot}/orcaslicer";
    in
    {
      volumes = {
        inherit root;
        data = "${root}/data";
      };
    };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;

  cfg = config.bfmp.containers.orcaslicer;
in
{
  options.bfmp.containers.orcaslicer = {
    enable = mkEnableOption "Enable OrcaSlicer";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues orcaslicerPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      orcaslicer = {
        image = "lscr.io/linuxserver/orcaslicer:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        # devices = [ "nvidia.com/gpu=all" ];
        networks = [ "local" ];
        volumes = [
          "${orcaslicerPaths.volumes.data}:/config"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          TITLE = "OrcaSlicer";
          DOCKER_MODS = "linuxserver/mods:universal-package-install";
          INSTALL_PACKAGES = "python3|python3-pip|python3-venv";
        };
        labels = util.mkDockerLabels {
          id = "orcaslicer";
          name = "orcaslicer";
          subdomain = "printer";
          port = 3000;
        };
      };
    };
  };
}
