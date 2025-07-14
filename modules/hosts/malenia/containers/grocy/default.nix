{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  grocyPaths =
    let
      root = "${vars.containersConfigRoot}/grocy";
    in
    {
      inherit root;
      config = "${root}/config";
    };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;

  cfg = config.bfmp.containers.grocy;
in
{
  options.bfmp.containers.grocy = {
    enable = mkEnableOption "Enable Grocy";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues grocyPaths
    );

    virtualisation.oci-containers.containers = {
      grocy = {
        image = "lscr.io/linuxserver/grocy:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [ "${grocyPaths.config}:/config" ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
        };
        labels = util.mkDockerLabels {
          id = "grocy";
          name = "Grocy";
          subdomain = "grocy";
          port = 80;
        };
      };
    };
  };
}
