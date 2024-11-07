{
  config,
  vars,
  username,
  ...
}:

let
  paperlessPaths =
    let
      root = "${vars.containersConfigRoot}/paperless";
      documentsRoot = vars.documentsMountLocation;
    in
    {
      volumes = {
        inherit root;
        data = "${root}/data";
        media = "${root}/media";
        export = "${root}/export";
        consume = "${root}/consume";
      };
      mounts = {
        documentsConsume = "${documentsRoot}/consume";
        documentsExport = "${documentsRoot}/export";
      };
    };

  puid = toString vars.defaultUserUID;
  guid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") (
    builtins.attrValues paperlessPaths.volumes
  );

  virtualisation.oci-containers.containers = {
    paperless = {
      image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      dependsOn = [ "paperless-redis" ];
      volumes = [
        "${paperlessPaths.volumes.data}:/usr/src/paperless/data"
        "${paperlessPaths.volumes.media}:/usr/src/paperless/media"
        "${paperlessPaths.mounts.documentsConsume}:/usr/src/paperless/consume"
        "${paperlessPaths.mounts.documentsExport}:/usr/src/paperless/export"
      ];
      environmentFiles = [ config.age.secrets.paperless.path ];
      environment = {
        USERMAP_UID = puid;
        USERMAP_GID = guid;
        PAPERLESS_TIME_ZONE = vars.timeZone;
        PAPERLESS_URL = "https://paperless.${vars.domain}";
        PAPERLESS_OCR_LANGUAGE = "por";
        PAPERLESS_OCR_LANGUAGES = "por eng";
        PAPERLESS_REDIS = "redis://paperless-redis:6379";
        PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.paperless.rule" = "Host(`paperless.${vars.domain}`)";
        "traefik.http.routers.paperless.entryPoints" = "https";
        "traefik.http.services.paperless.loadbalancer.server.port" = "8000";
        # Homepage
        "homepage.group" = "Documents";
        "homepage.name" = "Paperless";
        "homepage.icon" = "paperless.png";
        "homepage.href" = "https://paperless.${vars.domain}";
      };
    };
    paperless-redis = {
      image = "redis";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
    };
  };
}
