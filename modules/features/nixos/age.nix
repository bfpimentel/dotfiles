{ inputs, ... }:

{
  config.bfmp.nixos.sharedModules = [
    inputs.agenix.nixosModules.default
    (
      { config, ... }:
      {
        environment.systemPackages = [ inputs.agenix.packages.x86_64-linux.default ];

        age = {
          identityPaths = [ "/home/bruno/.ssh/id_personal" ];
          secrets = {
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
              group = "bruno";
            };

            # Containers
            bap-env = {
              file = ../../../secrets/bap-env.age;
              owner = "bruno";
              group = "bruno";
            };
            immich-env = {
              file = ../../../secrets/immich-env.age;
              owner = "bruno";
              group = "bruno";
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
          };
        };
      }
    )
  ];
}
