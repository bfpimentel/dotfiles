{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { ... }:
      {
        systemd.tmpfiles.rules = [
          "d /mnt/mass/containers/trek 0755 1000 1000 -"
          "d /mnt/mass/containers/trek/data 0755 1000 1000 -"
          "d /mnt/mass/containers/trek/uploads 0755 1000 1000 -"
        ];

        virtualisation.oci-containers.containers.trek = {
          image = "docker.io/mauriceboe/trek:latest";
          pull = "always";
          autoStart = true;
          ports = [ "3006:3000" ];
          environment = {
            NODE_ENV = "production";
            PORT = "3000";
            TZ = "America/Sao_Paulo";
            APP_URL = "https://trips.local.jalotopimentel.com";
            ALLOWED_ORIGINS = "https://trips.local.jalotopimentel.com";
          };
          volumes = [
            "/mnt/mass/containers/trek/data:/app/data"
            "/mnt/mass/containers/trek/uploads:/app/uploads"
          ];
          labels = {
            "shady.name" = "trek";
            "shady.url" = "https://trips.local.jalotopimentel.com";
          };
        };
      }
    )
  ];
}
