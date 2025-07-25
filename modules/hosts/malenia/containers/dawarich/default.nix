{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  dawarichPaths =
    let
      root = "${vars.containersConfigRoot}/dawarich";
    in
    {
      volumes = {
        inherit root;
        db = "${root}/db";
        redis = "${root}/redis";
        public = "${root}/public";
        watched = "${root}/watched";
        storage = "${root}/storage";
      };
    };

  cfg = config.bfmp.containers.dawarich;
in
{
  options.bfmp.containers.dawarich = {
    enable = mkEnableOption "Enable Dawarich";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues dawarichPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      dawarich-app = {
        image = "freikin/dawarich:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        entrypoint = "web-entrypoint.sh";
        cmd = [
          "bin/rails"
          "server"
          "-p"
          "3000"
          "-b"
          "::"
        ];
        dependsOn = [
          "dawarich-db"
          "dawarich-redis"
        ];
        networks = [ "local" ];
        volumes = [
          "${dawarichPaths.volumes.public}:/var/app/public"
          "${dawarichPaths.volumes.watched}:/var/app/tmp/imports/watched"
          "${dawarichPaths.volumes.storage}:/var/app/storage"
          "${dawarichPaths.volumes.db}:/dawarich_db_data"
        ];
        environmentFiles = [ config.age.secrets.dawarich.path ];
        labels = util.mkDockerLabels {
          id = "dawarich";
          name = "Dawarich";
          subdomain = "tracking";
          port = 3000;
        };
      };
      dawarich-worker = {
        image = "freikin/dawarich:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        entrypoint = "sidekiq-entrypoint.sh";
        cmd = [ "sidekiq" ];
        networks = [ "local" ];
        dependsOn = [
          "dawarich-db"
          "dawarich-redis"
          "dawarich-app"
        ];
        volumes = [
          "${dawarichPaths.volumes.public}:/var/app/public"
          "${dawarichPaths.volumes.watched}:/var/app/tmp/imports/watched"
          "${dawarichPaths.volumes.storage}:/var/app/storage"
        ];
        environmentFiles = [ config.age.secrets.dawarich.path ];
        labels = {
          "glance.parent" = "dawarich";
          "glance.name" = "Worker";
        };
      };
      dawarich-db = {
        image = "postgis/postgis:17-3.5-alpine";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [
          "${dawarichPaths.volumes.db}:/var/lib/postgresql/data"
        ];
        environmentFiles = [ config.age.secrets.dawarich.path ];
        labels = {
          "glance.parent" = "dawarich";
          "glance.name" = "Postgres";
        };
      };
      dawarich-redis = {
        image = "redis:7.4-alpine";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        cmd = [ "redis-server" ];
        networks = [ "local" ];
        volumes = [
          "${dawarichPaths.volumes.redis}:/data"
        ];
        labels = {
          "glance.parent" = "dawarich";
          "glance.name" = "Redis";
        };
      };
    };
  };
}
