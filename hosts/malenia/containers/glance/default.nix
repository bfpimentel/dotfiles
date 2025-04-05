{
  config,
  lib,
  vars,
  pkgs,
  ...
}:

with lib;
let
  glancePaths =
    let
      settingsFormat = pkgs.formats.yaml { };
      root = "${vars.containersConfigRoot}/glance";
    in
    {
      volumes = {
        inherit root;
      };
      generated = {
        glance = settingsFormat.generate "glance.yml" (import ./config/glance.nix);
      };
    };

  cfg = config.bfmp.containers.glance;
in
{
  options.bfmp.containers.glance = {
    enable = mkEnableOption "Enable Glance Dashboard";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues glancePaths.volumes
    );

    virtualisation.oci-containers.containers = {
      glance = {
        image = "glanceapp/glance:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
          "${glancePaths.generated.glance}:/app/config/glance.yml"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.glance.entrypoints" = "https";
          "traefik.http.routers.glance.rule" = "Host(`dash.${vars.domain}`)";
          "traefik.http.services.glance.loadbalancer.server.port" = "8080";
          # Glance
          "glance.id" = "glance";
          "glance.name" = "Glance";
          "glance.icon" = "si:glance";
          "glance.url" = "https://dash.${vars.domain}";
        };
      };
    };
  };
}
