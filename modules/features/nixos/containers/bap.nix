{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, ... }:
      {
        virtualisation.oci-containers.containers = {
          bap-server = {
            image = "ghcr.io/bfpimentel/bitwarden-alias-provider-server:latest";
            pull = "always";
            autoStart = true;
            environmentFiles = [ config.age.secrets.bap-env.path ];
            ports = [ "6223:6123" ];
          };

          bap-web = {
            image = "ghcr.io/bfpimentel/bitwarden-alias-provider-web:latest";
            pull = "always";
            autoStart = true;
            dependsOn = [ "bap-server" ];
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
