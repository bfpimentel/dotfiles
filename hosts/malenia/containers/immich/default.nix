{
  config,
  vars,
  username,
  ...
}:
let
  immichVersion = "v1.121.0";

  immichPaths =
    let
      root = "${vars.containersConfigRoot}/immich";
    in
    {
      volumes = {
        inherit root;
        machineLearning = "${root}/machine-learning";
      };
      mounts = {
        photos = vars.photosMountLocation;
      };
      postgres = "${root}/postgres";
    };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules =
    map (x: "d ${x} 0775 ${username} ${username} - -") (builtins.attrValues immichPaths.volumes)
    ++ map (x: "d ${x} 0775 postgres ${username} - -") [ immichPaths.postgres ];

  systemd.services = {
    podman-immich-postgres = {
      requires = [ "podman-immich-redis.service" ];
      after = [ "podman-immich-redis.service" ];
    };
  };

  virtualisation.oci-containers.containers = {
    immich = {
      image = "ghcr.io/immich-app/immich-server:${immichVersion}";
      autoStart = true;
      dependsOn = [
        "immich-redis"
        "immich-postgres"
        "immich-machine-learning"
      ];
      extraOptions = [ "--gpus=all" ];
      volumes = [ "${immichPaths.mounts.photos}:/usr/src/app/upload" ];
      environmentFiles = [ config.age.secrets.immich.path ];
      environment = {
        PUID = puid;
        PGID = pgid;
        TZ = vars.timeZone;
        DB_HOSTNAME = "immich-postgres";
        DB_USERNAME = "postgres";
        DB_DATABASE_NAME = "immich";
        REDIS_HOSTNAME = "immich-redis";
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.immich.entrypoints" = "https";
        "traefik.http.routers.immich.rule" = "Host(`photos.${vars.domain}`)";
        "traefik.http.services.immich.loadbalancer.server.port" = "2283";
        # Homepage
        "homepage.group" = "Media";
        "homepage.name" = "Immich";
        "homepage.icon" = "immich.svg";
        "homepage.href" = "https://photos.${vars.domain}";
        "homepage.weight" = "0";
        "homepage.widget.type" = "immich";
        "homepage.widget.key" = "{{HOMEPAGE_VAR_IMMICH_KEY}}";
        "homepage.widget.url" = "http://immich:2283";
        "homepage.widget.fields" = ''["photos", "videos", "storage"]'';
        "homepage.widget.version" = "2";
      };
    };

    immich-machine-learning = {
      image = "ghcr.io/immich-app/immich-machine-learning:${immichVersion}-cuda";
      autoStart = true;
      extraOptions = [ "--gpus=all" ];
      user = "${puid}:${pgid}";
      volumes = [ "${immichPaths.volumes.machineLearning}:/cache" ];
      environmentFiles = [ config.age.secrets.immich.path ];
      environment = {
        DB_HOSTNAME = "immich-postgres";
        DB_DATABASE_NAME = "immich";
        DB_USERNAME = "postgres";
        REDIS_HOSTNAME = "immich-redis";
      };
    };

    immich-postgres = {
      image = "tensorchord/pgvecto-rs:pg14-v0.2.1";
      autoStart = true;
      dependsOn = [ "immich-redis" ];
      extraOptions = [ "--user=100001:100001" ];
      volumes = [ "${immichPaths.postgres}:/var/lib/postgresql/data" ];
      environmentFiles = [ config.age.secrets.immich.path ];
      environment = {
        POSTGRES_DB = "immich";
        POSTGRES_USER = "postgres";
      };
    };

    immich-redis = {
      image = "redis";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
    };
  };
}
