{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, ... }:
      {
        virtualisation.oci-containers.containers = {
          eag-api = {
            image = "ghcr.io/bfpimentel/eag-api:latest";
            pull = "always";
            autoStart = true;
            environmentFiles = [ config.age.secrets.eag-env.path ];
            ports = [ "6223:6123" ];
          };

          eag-web = {
            image = "ghcr.io/bfpimentel/eag-web:latest";
            pull = "always";
            autoStart = true;
            dependsOn = [ "eag-api" ];
            environmentFiles = [ config.age.secrets.eag-env.path ];
            ports = [ "6224:6124" ];
            labels = {
              "shady.name" = "eag";
              "shady.url" = "https://eag.local.jalotopimentel.com";
            };
          };
        };
      }
    )
  ];
}
