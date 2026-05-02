{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { ... }:
      {
        virtualisation.oci-containers.containers.drip = {
          image = "ghcr.io/bfpimentel/drip:latest";
          pull = "always";
          autoStart = true;
          ports = [ "7123:7123" ];
          volumes = [
            "/mnt/share/containers/drip/uploads:/app/uploads"
            "/mnt/share/containers/drip/data:/app/data"
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
