{
  username,
  vars,
  pkgs,
  ...
}:

let
  apprisePaths =
    let
      root = "${vars.containersConfigRoot}/apprise";
    in
    {
      volumes = {
        inherit root;
        config = "${root}/config";
        attachments = "${root}/attachments";
      };
    };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") (
    builtins.attrValues apprisePaths.volumes
  );

  virtualisation.oci-containers.containers = {
    apprise = {
      image = "lscr.io/linuxserver/apprise-api:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      volumes = [
        "${apprisePaths.volumes.config}:/config"
        "${apprisePaths.volumes.attachments}:/attachments"
      ];
      environment = {
        TZ = vars.timeZone;
        PUID = puid;
        PGID = pgid;
        APPRISE_ATTACH_SIZE = "10";
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.apprise.rule" = "Host(`notify.${vars.domain}`)";
        "traefik.http.routers.apprise.entryPoints" = "https";
        "traefik.http.services.apprise.loadbalancer.server.port" = "8000";
        # Homepage
        "homepage.group" = "Monitoring";
        "homepage.name" = "Apprise";
        "homepage.icon" = "apprise.svg";
        "homepage.href" = "https://notify.${vars.domain}";
      };
    };
  };
}
