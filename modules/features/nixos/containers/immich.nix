{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, pkgs, ... }:
      {
        virtualisation.oci-containers.containers = {
          immich-server = {
            image = "ghcr.io/immich-app/immich-server:v2";
            pull = "always";
            autoStart = false;
            dependsOn = [
              "immich-redis"
              "immich-postgres"
            ];
            devices = [ "/dev/dri:/dev/dri" ];
            environmentFiles = [ config.age.secrets.immich-env.path ];
            ports = [ "2283:2283" ];
            volumes = [
              "/mnt/share/photos:/data"
              "/etc/localtime:/etc/localtime:ro"
            ];
            labels = {
              "shady.name" = "immich";
              "shady.url" = "https://photos.local.jalotopimentel.com";
            };
          };

          immich-machine-learning = {
            image = "ghcr.io/immich-app/immich-machine-learning:v2";
            pull = "always";
            autoStart = false;
            environmentFiles = [ config.age.secrets.immich-env.path ];
            volumes = [ "model-cache:/cache" ];
          };

          immich-redis = {
            image = "docker.io/valkey/valkey:9@sha256:546304417feac0874c3dd576e0952c6bb8f06bb4093ea0c9ca303c73cf458f63";
            pull = "always";
            autoStart = false;
          };

          immich-postgres = {
            image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23";
            pull = "always";
            autoStart = false;
            environment = {
              POSTGRES_INITDB_ARGS = "--data-checksums";
            };
            environmentFiles = [ config.age.secrets.immich-env.path ];
            volumes = [ "/mnt/share/containers/immich/postgres:/var/lib/postgresql/data" ];
            extraOptions = [ "--shm-size=128mb" ];
          };
        };

        systemd.services = {
          podman-immich-server.unitConfig.RequiresMountsFor = [
            "/mnt/share/photos"
            "/mnt/share/containers"
          ];

          podman-immich-postgres.unitConfig.RequiresMountsFor = [ "/mnt/share/containers" ];
        };
      }
    )
  ];
}
