{
  config,
  lib,
  vars,
  ...
}:

with lib;
let
  ddnsUpdaterPaths =
    let
      root = "${vars.containersConfigRoot}/ddns-updater";
    in
    {
      volumes = {
        inherit root;
      };
      files = {
        config = "${root}/config.json";
      };
    };

  cfg = config.bfmp.containers.ddns;
in
{
  options.bfmp.containers.ddns = {
    enable = mkEnableOption "Enable DDNS Updater";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules =
      map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
        builtins.attrValues ddnsUpdaterPaths.volumes
      )
      ++ map (x: "f ${x} 0600 ${vars.defaultUser} ${vars.defaultUser} - -") (
        builtins.attrValues ddnsUpdaterPaths.files
      );

    virtualisation.oci-containers.containers = {
      ddns-updater = {
        image = "ghcr.io/qdm12/ddns-updater:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [ "${ddnsUpdaterPaths.volumes.root}:/updater/data" ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.ddns-updater.rule" = "Host(`ddns.${vars.domain}`)";
          "traefik.http.routers.ddns-updater.entryPoints" = "https";
          "traefik.http.services.ddns-updater.loadbalancer.server.port" = "8000";
          # Homepage
          "homepage.group" = "Networking";
          "homepage.name" = "DDNS Updater";
          "homepage.icon" = "ddns-updater.svg";
          "homepage.href" = "https://ddns.${vars.domain}";
        };
      };
    };
  };
}
