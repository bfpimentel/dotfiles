{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, ... }:
      {
        virtualisation.oci-containers.containers.hass = {
          image = "ghcr.io/bfpimentel/hass-lb:latest";
          login = {
            registry = "ghcr.io";
            username = "bfpimentel";
            passwordFile = config.age.secrets.ghcr-token.path;
          };
          pull = "always";
          autoStart = true;
          ports = [ "8333:8333" ];
          environmentFiles = [ config.age.secrets.hass-env.path ];
          labels = {
            "shady.name" = "hass-lb";
            "shady.url" = "https://hass.local.jalotopimentel.com";
          };
        };
      }
    )
  ];
}
