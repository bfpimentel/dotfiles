{
  config,
  lib,
  ...
}:

with lib;
let
  inherit (config.bfmp.malenia) vars;

  beszelPaths =
    let
      root = "${vars.containersConfigRoot}/beszel";
    in
    {
      volumes = {
        inherit root;
      };
    };

  cfg = config.bfmp.containers.beszel;
in
{
  options.bfmp.containers.beszel = {
    enable = mkEnableOption "Enable Beszel and Beszel Agent";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues beszelPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      beszel = {
        image = "henrygd/beszel:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [ "${beszelPaths.volumes.root}:/beszel_data" ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.beszel.rule" = "Host(`monitor.${vars.domain}`)";
          "traefik.http.routers.beszel.entryPoints" = "https";
          "traefik.http.services.beszel.loadbalancer.server.port" = "8090";
          # Homepage
          "homepage.group" = "Management";
          "homepage.name" = "Beszel";
          "homepage.icon" = "beszel.svg";
          "homepage.href" = "https://monitor.${vars.domain}";
        };
      };
      beszel-agent = {
        image = "henrygd/beszel-agent:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock"
          "/mnt/media:/extra-filesystems/storage:ro"
        ];
        environment = {
          PORT = "45876";
          KEY = builtins.readFile config.age.secrets.beszel.path; # need to use anti-pattern here.
        };
      };
    };
  };
}
