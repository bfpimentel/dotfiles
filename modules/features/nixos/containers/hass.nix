{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, ... }:
      let
        registryLogin = {
          registry = "ghcr.io";
          username = "bfpimentel";
          passwordFile = config.age.secrets.ghcr-token.path;
        };
      in
      {
        systemd.tmpfiles.rules = [
          "d /mnt/mass/containers/hass 0755 1000 1000 -"
          "d /mnt/mass/containers/hass/data 0755 1000 1000 -"
        ];

        virtualisation.oci-containers.containers = {
          hass = {
            image = "ghcr.io/bfpimentel/hass-lb:latest";
            login = registryLogin;
            pull = "always";
            autoStart = true;
            dependsOn = [
              "hass-sync"
            ];
            ports = [ "8333:8333" ];
            environmentFiles = [ config.age.secrets.hass-env.path ];
            environment = {
              LAYOUT_SYNC_URL = "https://hass-sync.local.jalotopimentel.com";
            };
            labels = {
              "shady.name" = "hass-lb";
              "shady.url" = "https://hass.local.jalotopimentel.com";
            };
          };
          hass-sync = {
            image = "ghcr.io/bfpimentel/hass-lb-sync:latest";
            login = registryLogin;
            pull = "always";
            autoStart = true;
            user = "1000:1000";
            ports = [ "8334:8334" ];
            environment = {
              DATA_PATH = "/data/layout.json";
              PORT = "8334";
            };
            volumes = [
              "/mnt/mass/containers/hass/data:/data"
            ];
          };
        };
      }
    )
  ];
}
