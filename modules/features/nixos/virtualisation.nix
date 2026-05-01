{ ... }:

{
  config.bfmp.nixos.hosts.cherubim.modules = [
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

        security.sudo.extraRules = [
          {
            users = [ "bruno" ];
            commands = [
              {
                command = "/home/bruno/.nix-profile/bin/podman";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];
      }
    )
  ];
}
