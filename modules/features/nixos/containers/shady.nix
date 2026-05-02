{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { ... }:
      {
        virtualisation.oci-containers.containers.shady = {
          image = "ghcr.io/bfpimentel/shady:latest";
          pull = "always";
          autoStart = true;
          ports = [ "7112:7111" ];
          volumes = [
            "/run/podman/podman.sock:/var/run/docker.sock:ro"
            "/mnt/share/containers/shady/uploads:/app/uploads"
            "/mnt/share/containers/shady/config:/app/config"
          ];
        };
      }
    )
  ];
}
