{
  config,
  vars,
  username,
  ...
}:
let
  immichPath = "${vars.containersConfigRoot}/immich";
  immichPostgresPath = "${immichPath}/postgres";
  immichVersion = "v1.113.0";

  directories = [
    "${immichPath}"
    "${immichPath}/machine-learning"
  ];

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules =
    map (x: "d ${x} 0775 ${username} ${username} - -") directories
    ++ map (x: "d ${x} 0775 postgres ${username} - -") [ immichPostgresPath ];

  systemd.services = {
    podman-immich = {
      # serviceConfig = {
      #   User = username;
      #   Group = username;
      # };
      requires = [
        "podman-immich-redis.service"
        "podman-immich-postgres.service"
      ];
      after = [
        "podman-immich-redis.service"
        "podman-immich-postgres.service"
      ];
    };
    podman-immich-postgres = {
      # serviceConfig = {
      #   User = "postgres";
      #   Group = "postgres";
      # };
      requires = [ "podman-immich-redis.service" ];
      after = [ "podman-immich-redis.service" ];
    };
    podman-immich-machine-learning = {
      # serviceConfig = {
      #   User = username;
      #   Group = username;
      # };
    };
  };

  virtualisation.oci-containers.containers = {
    immich = {
      image = "ghcr.io/immich-app/immich-server:${immichVersion}";
      autoStart = true;
      extraOptions = [ "--device=/dev/dri:/dev/dri" ];
      volumes = [ "${vars.storageMountLocation}/photos:/usr/src/app/upload" ];
      environmentFiles = [ config.age.secrets.immich.path ];
      environment = {
        PUID = puid;
        PGID = pgid;
        TZ = vars.timeZone;
        IMMICH_PORT = "3001";
        IMMICH_HOST = "0.0.0.0";
        DB_HOSTNAME = "immich-postgres";
        DB_USERNAME = "postgres";
        DB_DATABASE_NAME = "immich";
        REDIS_HOSTNAME = "immich-redis";
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.immich.entrypoints" = "https";
        "traefik.http.routers.immich.rule" = "Host(`photos.${vars.domain}`)";
        "traefik.http.services.immich.loadbalancer.server.port" = "3001";
      };
    };

    immich-machine-learning = {
      image = "ghcr.io/immich-app/immich-machine-learning:${immichVersion}-cuda";
      autoStart = true;
      extraOptions = [
        "--device=/dev/dri:/dev/dri"
        # "--user=${puid}:${pgid}"
      ];
      volumes = [ "${immichPath}/machine-learning:/config/machine-learning" ];
      environmentFiles = [ config.age.secrets.immich.path ];
      environment = {
        IMMICH_PORT = "3001";
        IMMICH_HOST = "0.0.0.0";
        DB_HOSTNAME = "immich-postgres";
        DB_DATABASE_NAME = "immich";
        DB_USERNAME = "postgres";
        REDIS_HOSTNAME = "immich-redis";
      };
    };

    immich-postgres = {
      image = "tensorchord/pgvecto-rs:pg14-v0.2.1";
      autoStart = true;
      extraOptions = [ "--user=100001:100001" ];
      # cmd = [
      #   "postgres -c shared_preload_libraries=vectors.so -c 'search_path=\"$$user\", public, vectors' -c logging_collector=on -c max_wal_size=2GB -c shared_buffers=512MB -c wal_compression=on"
      # ];
      volumes = [ "${immichPostgresPath}:/var/lib/postgresql/data" ];
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
