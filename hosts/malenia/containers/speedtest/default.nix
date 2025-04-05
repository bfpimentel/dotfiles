{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  speedtestPaths =
    let
      root = "${vars.containersConfigRoot}/speedtest-tracker";
    in
    {
      volumes = {
        inherit root;
      };
    };

  puid = toString vars.defaultUserUID;
  guid = toString vars.defaultUserGID;

  cfg = config.bfmp.containers.speedtest;
in
{
  options.bfmp.containers.speedtest = {
    enable = mkEnableOption "Enable Speedtest Tracker";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues speedtestPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      speedtest-tracker = {
        image = "lscr.io/linuxserver/speedtest-tracker:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [ "${speedtestPaths.volumes.root}:/config" ];
        environmentFiles = [ config.age.secrets.speedtest-tracker.path ];
        environment = {
          TZ = vars.timeZone;
          DISPLAY_TIMEZONE = vars.timeZone;
          PUID = puid;
          PGID = guid;
          DB_CONNECTION = "sqlite";
          SPEEDTEST_SERVERS = "57971";
          SPEEDTEST_SCHEDULE = "0 * * * *";
          APP_URL = "https://speedtest.${vars.domain}";
          APP_DEBUG = "false";
          PRUNE_RESULTS_OLDER_THAN = "30";
        };
        labels = util.mkDockerLabels {
          id = "speedtest-tracker";
          name = "Speedtest Tracker";
          subdomain = "speedtest";
          port = 80;
        };
      };
    };
  };
}
