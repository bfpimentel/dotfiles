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
