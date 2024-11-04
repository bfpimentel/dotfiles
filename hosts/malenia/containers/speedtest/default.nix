{
  vars,
  username,
  config,
  ...
}:

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
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") (
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
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.speedtest-tracker.rule" = "Host(`speedtest.${vars.domain}`)";
        "traefik.http.routers.speedtest-tracker.entryPoints" = "https";
        "traefik.http.services.speedtest-tracker.loadbalancer.server.port" = "80";
        # Homepage
        "homepage.group" = "Networking";
        "homepage.name" = "Speedtest Tracker";
        "homepage.icon" = "speedtest-tracker.png";
        "homepage.href" = "https://speedtest.${vars.domain}";
        "homepage.widget.type" = "speedtest";
        "homepage.widget.url" = "http://speedtest-tracker:80";
      };
    };
  };
}
