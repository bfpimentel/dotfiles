{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { ... }:
      {
        virtualisation = {
          containers.enable = true;
          podman = {
            enable = true;
            dockerCompat = true;
          };
        };
      }
    )
  ];
}
