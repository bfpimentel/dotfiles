{
  config,
  lib,
  vars,
  ...
}:

with lib;
let
  hoarderPaths =
    let
      root = "${vars.containersConfigRoot}/hoarder";
    in
    {
      volumes = {
        inherit root;
        data = "${root}/data";
        meili = "${root}/meili";
      };
    };

  cfg = config.bfmp.containers.hoarder;
in
{
  options.bfmp.containers.hoarder = {
    enable = mkEnableOption "Enable Hoarder";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues hoarderPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      hoarder = {
        image = "ghcr.io/hoarder-app/hoarder:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [ "${hoarderPaths.volumes.data}:/data" ];
        environmentFiles = [ config.age.secrets.hoarder.path ];
        environment = {
          BROWSER_WEB_URL = "http://hoarder-chrome:9222";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.hoarder.entrypoints" = "https";
          "traefik.http.routers.hoarder.rule" = "Host(`hoarder.${vars.domain}`)";
          "traefik.http.services.hoarder.loadbalancer.server.port" = "3000";
          # Homepage
          "homepage.group" = "Misc";
          "homepage.name" = "Hoarder";
          "homepage.icon" = "sh-hoarder.png";
          "homepage.href" = "https://hoarder.${vars.domain}";
        };
      };
      hoarder-chrome = {
        image = "gcr.io/zenika-hub/alpine-chrome:123";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        cmd = [
          "--no-sandbox"
          "--disable-gpu"
          "--disable-dev-shm-usage"
          "--remote-debugging-address=0.0.0.0"
          "--remote-debugging-port=9222"
          "--hide-scrollbars"
        ];
      };
      hoarder-meili = {
        image = "getmeili/meilisearch:v1.11.1";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [ "${hoarderPaths.volumes.meili}:/meili_data" ];
        environmentFiles = [ config.age.secrets.hoarder.path ];
        environment = {
          MEILI_NO_ANALYTICS = "true";
        };
      };
    };
  };
}
