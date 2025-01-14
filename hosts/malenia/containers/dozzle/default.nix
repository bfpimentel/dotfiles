{ config, lib, ... }:

with lib;
let
  inherit (config.bfmp.malenia) vars;

  cfg = config.bfmp.containers.dozzle;
in
{
  options.bfmp.containers.dozzle = {
    enable = mkEnableOption "Enable Dozzle";
  };

  config = mkIf cfg.enable {
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
  };
}
