{ vars, ... }:

{
  virtualisation.oci-containers.containers = {
    dozzle = {
      image = "amir20/dozzle:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.dozzle.rule" = "Host(`logs.${vars.domain}`)";
        "traefik.http.routers.dozzle.entryPoints" = "https";
        "traefik.http.services.dozzle.loadbalancer.server.port" = "8080";
        # Homepage
        "homepage.group" = "Monitoring";
        "homepage.name" = "Dozzle";
        "homepage.icon" = "dozzle.svg";
        "homepage.href" = "https://logs.${vars.domain}";
      };
    };
  };
}
