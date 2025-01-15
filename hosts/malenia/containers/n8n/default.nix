{
  config,
  lib,
  vars,
  ...
}:

with lib;
let
  n8nPaths =
    let
      root = "${vars.containersConfigRoot}/n8n";
    in
    {
      volumes = {
        inherit root;
        data = "${root}/data";
        files = "${root}/files";
      };
    };

  cfg = config.bfmp.containers.n8n;
in
{
  options.bfmp.containers.n8n = {
    enable = mkEnableOption "Enable n8n";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues n8nPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      n8n = {
        image = "docker.n8n.io/n8nio/n8n";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [
          "${n8nPaths.volumes.data}:/home/node/.n8n"
          "${n8nPaths.volumes.files}:/files"
        ];
        environment = {
          N8N_HOST = "n8n.${vars.domain}";
          N8N_PORT = "5678";
          N8N_PROTOCOL = "https";
          WEBHOOK_URL = "https://n8n.${vars.domain}/";
          NODE_ENV = "production";
          GENERIC_TIMEZONE = vars.timeZone;
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.n8n.rule" = "Host(`n8n.${vars.domain}`)";
          "traefik.http.routers.n8n.entryPoints" = "https";
          "traefik.http.services.n8n.loadbalancer.server.port" = "5678";
          # Homepage
          "homepage.group" = "Misc";
          "homepage.name" = "n8n";
          "homepage.icon" = "n8n.svg";
          "homepage.href" = "https://n8n.${vars.domain}";
        };
      };
    };
  };
}
