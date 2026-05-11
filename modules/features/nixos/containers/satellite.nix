{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { util, ... }:
      {
        virtualisation.oci-containers.containers.satellite = {
          image = "ghcr.io/bfpimentel/satellite:latest";
          pull = "always";
          autoStart = true;
          ports = [ "6333:6333" ];
          volumes = [ "/mnt/share/containers/satellite/data:/app/data" ];
          labels = {
            "shady.name" = "satellite";
            "shady.url" = "https://satellite.local.jalotopimentel.com";
          };
        };

        systemd.services.podman-satellite = util.mkContainerWaitMount [ "mnt-share-containers.automount" ];
      }
    )
  ];
}
