{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { util, ... }:
      {
        systemd.tmpfiles.rules = [
          "d /mnt/mass/containers/satellite/data 0755 1000 1000 -"
        ];

        virtualisation.oci-containers.containers.satellite = {
          image = "ghcr.io/bfpimentel/satellite:latest";
          pull = "always";
          autoStart = true;
          ports = [ "6333:6333" ];
          volumes = [ "/mnt/mass/containers/satellite/data:/app/data" ];
          labels = {
            "shady.name" = "satellite";
            "shady.url" = "https://satellite.local.jalotopimentel.com";
          };
        };
      }
    )
  ];
}
