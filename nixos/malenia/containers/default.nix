{ ... }:

{
  imports = [
    ./traefik
    ./dozzle
    ./homepage
    ./speedtest
    ./baikal
    ./vaultwarden
    ./arr
    ./qbittorrent
    ./immich
    ./plex
    ./overseerr
    ./tautulli
    ./authentik
    ./ntfy
  ];

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers = {
      backend = "podman";
    };
  };

  networking.firewall.interfaces."podman+".allowedUDPPorts = [
    53
    5353
  ];
}
