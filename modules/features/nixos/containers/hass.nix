{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { util, ... }:
      {
        virtualisation.oci-containers.containers.hass = {
          image = "ghcr.io/bfpimentel/hass-lb:latest";
          pull = "always";
          autoStart = true;
          ports = [ "8333:8333" ];
          environment = {
            HOME_ASSISTANT_URL = "https://home.local.jalotopimentel.com";
          };
          labels = {
            "shady.name" = "hass-lb";
            "shady.url" = "https://hass.local.jalotopimentel.com";
          };
        };
      }
    )
  ];
}
