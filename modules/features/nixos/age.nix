{ inputs, ... }:

{
  config.bfmp.nixos.sharedModules = [
    inputs.agenix.nixosModules.default
    (
      { config, pkgs, ... }:
      {
        environment.systemPackages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];
        age.identityPaths = [ "/home/bruno/.ssh/id_personal" ];
      }
    )
  ];

  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, ... }:
      {
        age.secrets = {
          # General
          nginx-env = {
            file = ../../../secrets/nginx-env.age;
            owner = "acme";
            group = "nginx";
            mode = "0440";
          };

          # Share
          share-credentials = {
            file = ../../../secrets/share-credentials.age;
            owner = "bruno";
            group = "users";
          };

          # Containers
          bap-env = {
            file = ../../../secrets/bap-env.age;
            owner = "bruno";
            group = "users";
          };
          immich-env = {
            file = ../../../secrets/immich-env.age;
            owner = "bruno";
            group = "users";
          };

          # Hermes
          hermes-env = {
            file = ../../../secrets/hermes-env.age;
            owner = "hermes";
            group = "hermes";
          };
          hermes-auth = {
            file = ../../../secrets/hermes-auth.age;
            owner = "hermes";
            group = "hermes";
          };

          # WireGuard
          wireguard-powers-private = {
            file = ../../../secrets/wireguard-powers-private.age;
            owner = "systemd-network";
            group = "systemd-network";
            mode = "0400";
          };
        };
      }
    )
  ];

  config.bfmp.nixos.hosts.thronos.modules = [
    (
      { ... }:
      {
        age.secrets.wireguard-thronos-private = {
          file = ../../../secrets/wireguard-thronos-private.age;
          owner = "systemd-network";
          group = "systemd-network";
          mode = "0400";
        };
      }
    )
  ];
}
