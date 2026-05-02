{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { ... }:
      {
        virtualisation.oci-containers.containers = {
          qbittorrent = {
            image = "lscr.io/linuxserver/qbittorrent:latest";
            pull = "always";
            autoStart = true;
            environment = {
              PUID = "1000";
              PGID = "1000";
              TZ = "America/Sao_Paulo";
              WEBUI_PORT = "8080";
              TORRENTING_PORT = "6881";
            };
            ports = [
              "8080:8080"
              "6881:6881"
              "6881:6881/udp"
            ];
            volumes = [
              "/mnt/share/containers/qbittorrent/data:/config"
              "/mnt/share/downloads:/downloads"
            ];
            labels = {
              "shady.name" = "qbittorrent";
              "shady.url" = "https://torrent.local.jalotopimentel.com";
            };
          };

          jellyfin = {
            image = "lscr.io/linuxserver/jellyfin:latest";
            pull = "always";
            autoStart = true;
            devices = [ "/dev/dri:/dev/dri" ];
            environment = {
              PUID = "1000";
              PGID = "1000";
              TZ = "America/Sao_Paulo";
              JELLYFIN_PublishedServerUrl = "https://media.local.jalotopimentel.com";
            };
            ports = [ "8096:8096" ];
            volumes = [
              "/mnt/share/containers/jellyfin/data:/data"
              "/mnt/share/media:/media"
            ];
            labels = {
              "shady.name" = "jellyfin";
              "shady.url" = "https://media.local.jalotopimentel.com";
            };
          };
        };

        systemd.services = {
          podman-qbittorrent.unitConfig.RequiresMountsFor = [
            "/mnt/share/containers"
            "/mnt/share/downloads"
          ];

          podman-jellyfin.unitConfig.RequiresMountsFor = [
            "/mnt/share/containers"
            "/mnt/share/media"
          ];
        };
      }
    )
  ];
}
