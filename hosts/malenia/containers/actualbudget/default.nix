{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  actualbudgetPaths =
    let
      root = "${vars.containersConfigRoot}/actualbudget";
    in
    {
      volumes = {
        inherit root;
        data = "${root}/data";
      };
    };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;

  cfg = config.bfmp.containers.actualbudget;
in
{
  options.bfmp.containers.actualbudget = {
    enable = mkEnableOption "Enable ActualBudget";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues actualbudgetPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      actualbudget = {
        image = "docker.io/actualbudget/actual-server:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [
          "${actualbudgetPaths.volumes.data}:/data"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
        };
        labels = util.mkDockerLabels {
          id = "actualbudget";
          name = "ActualBudget";
          subdomain = "budget";
          port = 5006;
        };
      };
    };
  };
}
