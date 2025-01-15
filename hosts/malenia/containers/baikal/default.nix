{
  config,
  lib,
  vars,
  ...
}:

with lib;
let
  baikalPaths =
    let
      root = "${vars.containersConfigRoot}/baikal";
    in
    {
      inherit root;
      data = "${root}/data";
      config = "${root}/config";
    };

  cfg = config.bfmp.containers.baikal;
in
{
  options.bfmp.containers.baikal = {
    enable = mkEnableOption "Enable Baikal";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues baikalPaths
    );

    virtualisation.oci-containers.containers = {
      baikal = {
        image = "ckulka/baikal:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [
          "${baikalPaths.data}:/var/www/baikal/Specific"
          "${baikalPaths.config}:/var/www/baikal/config"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.baikal.rule" = "Host(`baikal.${vars.domain}`)";
          "traefik.http.routers.baikal.entryPoints" = "https";
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
