{
  config,
  lib,
  ...
}:

with lib;
let
  inherit (config.bfmp.malenia) vars;

  authentikPaths =
    let
      root = "${vars.containersConfigRoot}/authentik";
    in
    {
      volumes = {
        inherit root;
        media = "${root}/media";
        templates = "${root}/templates";
        certs = "${root}/certs";
      };
      postgres = "${root}/db";
    };

  cfg = config.bfmp.containers.authentik;
in
{
  options.bfmp.containers.authentik = {
    enable = mkEnableOption "Enable Authentik";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules =
      map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
        builtins.attrValues authentikPaths.volumes
      )
      ++ map (x: "d ${x} 0775 postgres ${vars.defaultUser} - -") [ authentikPaths.postgres ];

    virtualisation.oci-containers.containers = {
      authentik-server = {
        image = "ghcr.io/goauthentik/server:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        cmd = [ "server" ];
        dependsOn = [
          "authentik-db"
          "authentik-redis"
        ];
        ports = [ "9000:9000" ];
        volumes = [
          "${authentikPaths.volumes.media}:/media"
          "${authentikPaths.volumes.templates}:/templates"
        ];
        environmentFiles = [ config.age.secrets.authentik.path ];
        environment = {
          AUTHENTIK_REDIS__HOST = "authentik-redis";
          AUTHENTIK_POSTGRESQL__HOST = "authentik-db";
          AUTHENTIK_POSTGRESQL__USER = "authentik";
          AUTHENTIK_POSTGRESQL__NAME = "authentik";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.authentik.entrypoints" = "https";
          "traefik.http.routers.authentik.rule" = "Host(`auth.${vars.domain}`)";
          "traefik.http.services.authentik.loadbalancer.server.port" = "9000";
          # Homepage
          "homepage.group" = "Auth";
          "homepage.name" = "Authentik";
          "homepage.icon" = "authentik.png";
          "homepage.href" = "https://auth.${vars.externalDomain}";
        };
      };
      authentik-worker = {
        image = "ghcr.io/goauthentik/server:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        cmd = [ "worker" ];
        dependsOn = [
          "authentik-db"
          "authentik-redis"
        ];
        volumes = [
          "${authentikPaths.volumes.media}:/media"
          "${authentikPaths.volumes.templates}:/templates"
          "${authentikPaths.volumes.certs}:/certs"
        ];
        environmentFiles = [ config.age.secrets.authentik.path ];
        environment = {
          AUTHENTIK_REDIS__HOST = "authentik-redis";
          AUTHENTIK_POSTGRESQL__HOST = "authentik-db";
          AUTHENTIK_POSTGRESQL__USER = "authentik";
          AUTHENTIK_POSTGRESQL__NAME = "authentik";
        };
      };
      authentik-db = {
        image = "docker.io/library/postgres:12-alpine";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [
          "${authentikPaths.postgres}:/var/lib/postgresql/data"
        ];
        environmentFiles = [ config.age.secrets.authentik.path ];
        environment = {
          POSTGRES_USER = "authentik";
          POSTGRES_DB = "authentik";
        };
      };
      authentik-redis = {
        image = "docker.io/library/redis:alpine";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
      };
    };
  };
}
