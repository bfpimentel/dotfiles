{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { ... }:
      {
        systemd.tmpfiles.rules = [
          "d /mnt/mass/containers/calibre-web 0755 1000 1000 -"
          "d /mnt/mass/containers/calibre-web/config 0755 1000 1000 -"
          "d /mnt/mass/containers/calibre-web/data 0755 1000 1000 -"
          "d /mnt/mass/containers/koreader 0755 1000 1000 -"
          "d /mnt/mass/containers/koreader/data 0755 1000 1000 -"
        ];

        virtualisation.oci-containers.containers = {
          calibre-web = {
            image = "lscr.io/linuxserver/calibre-web:latest";
            pull = "always";
            autoStart = true;
            environment = {
              PUID = "1000";
              PGID = "1000";
              TZ = "America/Sao_Paulo";
            };
            ports = [ "8083:8083" ];
            volumes = [
              "/mnt/mass/containers/calibre-web/config:/config"
              "/mnt/mass/containers/calibre-web/data:/data"
              "/mnt/mass/media/books:/books"
            ];
            labels = {
              "shady.name" = "calibre-web";
              "shady.url" = "https://books.local.jalotopimentel.com";
            };
          };

          koreader-sync = {
            image = "docker.io/koreader/kosync:latest";
            pull = "always";
            autoStart = true;
            ports = [ "17200:17200" ];
            volumes = [
              "/mnt/mass/containers/koreader/data:/var/lib/redis"
            ];
            environment = {
              ENABLE_USER_REGISTRATION = "true";
            };
            labels = {
              "shady.name" = "books-sync";
              "shady.url" = "https://books-sync.local.jalotopimentel.com";
            };
          };
        };
      }
    )
  ];
}
