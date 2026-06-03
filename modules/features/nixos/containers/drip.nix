{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { ... }:
      {
        systemd.tmpfiles.rules = [
          "d /mnt/mass/containers/drip 0755 1000 1000 -"
          "d /mnt/mass/containers/drip/data 0755 1000 1000 -"
          "d /mnt/mass/containers/drip/uploads 0755 1000 1000 -"
        ];

        virtualisation.oci-containers.containers.drip = {
          image = "ghcr.io/bfpimentel/drip:latest";
          pull = "always";
          autoStart = true;
          user = "1000:1000";
          ports = [ "7123:7123" ];
          volumes = [
            "/mnt/mass/containers/drip/uploads:/app/uploads"
            "/mnt/mass/containers/drip/data:/app/data"
          ];
          labels = {
            "shady.name" = "drip";
            "shady.url" = "https://drip.local.jalotopimentel.com";
          };
        };
      }
    )
  ];
}
