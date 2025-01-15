{
  config,
  lib,
  vars,
  ...
}:

with lib;
let
  cfg = config.bfmp.containers.it-tools;
in
{
  options.bfmp.containers.it-tools = {
    enable = mkEnableOption "Enable IT-Tools";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      it-tools = {
        image = "corentinth/it-tools";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.it-tools.rule" = "Host(`tools.${vars.domain}`)";
          "traefik.http.routers.it-tools.entryPoints" = "https";
          "traefik.http.services.it-tools.loadbalancer.server.port" = "80";
          # Homepage
          "homepage.group" = "Misc";
          "homepage.name" = "IT Tools";
          "homepage.icon" = "it-tools.svg";
          "homepage.href" = "https://tools.${vars.domain}";
        };
      };
    };
  };
}
