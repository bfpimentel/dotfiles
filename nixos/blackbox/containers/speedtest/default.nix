{ vars, username, ... }:

let
  speedtestPath = "${vars.containersConfigRoot}/speedtest-tracker";

  directories = [ speedtestPath ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers = {
    containers = {
      speedtest-tracker = {
        image = "henrywhitaker3/speedtest-tracker:latest";
        autoStart = true;
        volumes = [ "${speedtestPath}:/config" ];
        environment = {
          TZ = vars.timeZone;
          PGID = "1000";
          PUID = "1000";
          OOKLA_EULA_GDPR = "true";
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
