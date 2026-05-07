{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { ... }:
      {
        virtualisation.oci-containers.containers.dozzle = {
          image = "ghcr.io/amir20/dozzle:latest";
          pull = "always";
          autoStart = true;
          ports = [ "7113:8080" ];
          volumes = [
            "/run/podman/podman.sock:/var/run/docker.sock:ro"
            "/mnt/share/containers/dozzle/data:/data"
          ];
          labels = {
            "shady.name" = "dozzle";
            "shady.url" = "https://logs.local.jalotopimentel.com";
          };
        };

        systemd.services.podman-dozzle.unitConfig.RequiresMountsFor = [ "/mnt/share/containers" ];
      }
    )
  ];
}
