{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { ... }:
      {
        systemd.tmpfiles.rules = [
          "d /mnt/mass/containers/shady/uploads 0755 1000 1000 -"
          "d /mnt/mass/containers/shady/config 0755 1000 1000 -"
        ];

        virtualisation.oci-containers.containers.shady = {
          image = "ghcr.io/bfpimentel/shady:latest";
          pull = "always";
          autoStart = true;
          ports = [ "7112:7111" ];
          volumes = [
            "/run/podman/podman.sock:/var/run/docker.sock:ro"
            "/mnt/mass/containers/shady/uploads:/app/uploads"
            "/mnt/mass/containers/shady/config:/app/config"
          ];
        };
      }
    )
  ];
}
