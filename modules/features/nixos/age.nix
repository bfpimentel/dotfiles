{ inputs, ... }:

{
  config.bfmp.nixos.hosts.cherubim.modules = [
    inputs.agenix.nixosModules.default
    (
      { config, ... }:
      {
        environment.systemPackages = [ inputs.agenix.packages.x86_64-linux.default ];

        age = {
          identityPaths = [ "/home/bruno/.ssh/id_personal" ];
          secrets = {
            hermes-agent.file = ../../../secrets/hermes-agent.age;
          };
        };
      }
    )
  ];
}
