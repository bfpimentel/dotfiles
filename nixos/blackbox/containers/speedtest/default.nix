{
  vars,
  username,
  config,
  ...
}:

let
  speedtestPath = "${vars.containersConfigRoot}/speedtest-tracker";

  directories = [ speedtestPath ];

  puid = toString vars.defaultUserUID;
  guid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers = {
    containers = {
      speedtest-tracker = {
        image = "lscr.io/linuxserver/speedtest-tracker:latest";
        autoStart = true;
        volumes = [ "${speedtestPath}:/config" ];
        environmentFiles = [ config.age.secrets.speedtest-tracker.path ];
        environment = {
          APP_TIMEZONE = vars.timeZone;
          PUID = puid;
          PGID = guid;
          DB_CONNECTION = "sqlite";
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
        };
      };
    };
  };
}
