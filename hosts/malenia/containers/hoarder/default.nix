{
  config,
  lib,
  vars,
  util,
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
        labels = util.mkDockerLabels {
          id = "hoarder";
          name = "Hoarder";
          subdomain = "bookmarks";
          port = 3000;
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
        labels = {
          "glance.parent" = "hoarder";
          "glance.name" = "Chrome";
        };
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
        labels = {
          "glance.parent" = "hoarder";
          "glance.name" = "Meili";
        };
      };
    };
  };
}
