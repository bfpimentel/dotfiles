{ config, ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, ... }:
      {
        virtualisation.oci-containers.containers = {
          bitwarden-alias-provider-server = {
            image = "ghcr.io/bfpimentel/bitwarden-alias-provider-server:latest";
            pull = "always";
            autoStart = true;
            environmentFiles = [ config.age.secrets.bap-env.path ];
            ports = [ "6223:6123" ];
          };

          bitwarden-alias-provider-web = {
            image = "ghcr.io/bfpimentel/bitwarden-alias-provider-web:latest";
            pull = "always";
            autoStart = true;
            dependsOn = [ "bitwarden-alias-provider-server" ];
            environmentFiles = [ config.age.secrets.bap-env.path ];
            ports = [ "6224:6124" ];
            labels = {
              "shady.name" = "bap";
              "shady.url" = "https://bap.local.jalotopimentel.com";
            };
          };
        };
      }
    )
  ];
}
