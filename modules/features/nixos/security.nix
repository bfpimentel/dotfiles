{ ... }:

{
  config.bfmp.nixos.sharedModules = [
    (
      { ... }:
      {
        security.sudo.extraRules = [
          {
            users = [ "bruno" ];
            commands = [
              {
                command = "/run/current-system/sw/bin/nix-env";
                options = [ "NOPASSWD" ];
              }
              {
                command = "/nix/var/nix/profiles/system/bin/switch-to-configuration";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];
      }
    )
  ];

  config.bfmp.nixos.hosts.powers.modules = [
    (
      { ... }:
      {
        security.sudo.extraRules = [
          {
            users = [ "bruno" ];
            commands = [
              {
                command = "/run/current-system/sw/bin/podman";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];
      }
    )
  ];
}
