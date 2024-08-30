{ vars, ... }:

{
  virtualisation.oci-containers = {
    containers = {
      dozzle = {
        image = "amir20/dozzle:latest";
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.dozzle.rule" = "Host(`logs.${vars.domain}`)";
          "traefik.http.routers.dozzle.entryPoints" = "https";
          "traefik.http.routers.dozzle.service" = "dozzle";
          "traefik.http.services.dozzle.loadbalancer.server.port" = "8080";
          "homepage.group" = "Services";
          "homepage.name" = "Dozzle";
          "homepage.icon" = "dozzle.svg";
          "homepage.href" = "https://dozzle.${vars.domain}";
        };
      };
    };
  };
}
