{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { util, ... }:
      {
        systemd.tmpfiles.rules = [
          "d /mnt/mass/containers/dozzle/data 0755 1000 1000 -"
        ];

        virtualisation.oci-containers.containers.dozzle = {
          image = "ghcr.io/amir20/dozzle:latest";
          pull = "always";
          autoStart = true;
          ports = [ "7113:8080" ];
          volumes = [
            "/run/podman/podman.sock:/var/run/docker.sock:ro"
            "/mnt/mass/containers/dozzle/data:/data"
          ];
          labels = {
            "shady.name" = "dozzle";
            "shady.url" = "https://logs.local.jalotopimentel.com";
          };
        };
      }
    )
  ];
}
