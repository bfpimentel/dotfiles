{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, ... }:
      {
        systemd.tmpfiles.rules = [
          "d /mnt/mass/containers/searxng/cache 0755 1000 1000 -"
          "d /mnt/mass/containers/searxng/config 0755 1000 1000 -"
          "d /mnt/mass/containers/searxng/valkey 0755 999 root -"
        ];

        virtualisation.oci-containers.containers = {
          searxng = {
            image = "docker.io/searxng/searxng:latest";
            pull = "always";
            autoStart = true;
            dependsOn = [ "searxng-valkey" ];
            environment = {
              SEARXNG_BASE_URL = "https://search.local.jalotopimentel.com/";
              SEARXNG_BIND_ADDRESS = "0.0.0.0";
              SEARXNG_LIMITER = "false";
              SEARXNG_VALKEY_URL = "valkey://searxng-valkey:6379/0";
            };
            environmentFiles = [ config.age.secrets.searxng-env.path ];
            ports = [ "7114:8080" ];
            volumes = [
              "/mnt/mass/containers/searxng/cache:/var/cache/searxng"
              "/mnt/mass/containers/searxng/config:/etc/searxng"
            ];
            labels = {
              "shady.name" = "searxng";
              "shady.url" = "https://search.local.jalotopimentel.com";
            };
          };

          searxng-valkey = {
            image = "docker.io/valkey/valkey:9-alpine";
            pull = "always";
            autoStart = true;
            cmd = [
              "valkey-server"
              "--save"
              "30"
              "1"
              "--loglevel"
              "warning"
            ];
            volumes = [ "/mnt/mass/containers/searxng/valkey:/data" ];
          };
        };
      }
    )
  ];
}
