{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { util, ... }:
      {
        systemd.tmpfiles.rules = [
          "d /mnt/mass/containers/drip/uploads 0755 1000 1000 -"
          "d /mnt/mass/containers/drip/data 0755 1000 1000 -"
        ];

        virtualisation.oci-containers.containers.drip = {
          image = "ghcr.io/bfpimentel/drip:latest";
          pull = "always";
          autoStart = true;
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
