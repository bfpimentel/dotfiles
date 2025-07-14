{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  freshrssPaths =
    let
      root = "${vars.containersConfigRoot}/freshrss";
    in
    {
      inherit root;
      config = "${root}/config";
    };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;

  cfg = config.bfmp.containers.freshrss;
in
{
  options.bfmp.containers.freshrss = {
    enable = mkEnableOption "Enable FreshRSS";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues freshrssPaths
    );

    virtualisation.oci-containers.containers = {
      freshrss = {
        image = "lscr.io/linuxserver/freshrss:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [ "${freshrssPaths.config}:/config" ];
        environmentFiles = [ config.age.secrets.freshrss.path ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
        };
        labels = util.mkDockerLabels {
          id = "freshrss";
          name = "FreshRSS";
          subdomain = "rss";
          port = 80;
        };
      };
    };
  };
}
