{ username, vars, ... }:

let
  baikalPath = "${vars.containersConfigRoot}/baikal";

  directories = [
    "${baikalPath}"
    "${baikalPath}/data"
    "${baikalPath}/config"
  ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers = {
    containers = {
      baikal = {
        image = "ckulka/baikal:latest";
        autoStart = true;
        volumes = [
          "${baikalPath}/data:/var/www/baikal/Specific"
          "${baikalPath}/config:/var/www/baikal/config"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.baikal.rule" = "Host(`baikal.${vars.domain}`)";
          "traefik.http.routers.baikal.entryPoints" = "https";
          "traefik.http.routers.baikal.service" = "baikal";
          "traefik.http.services.baikal.loadbalancer.server.port" = "80";
          # Homepage
          "homepage.group" = "Documents";
          "homepage.name" = "Baikal";
          "homepage.icon" = "baikal.png";
          "homepage.href" = "https://baikal.${vars.domain}";
        };
      };
    };
  };
}
