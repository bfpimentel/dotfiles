{ ... }:

{
  imports = [
    ./traefik
    ./dozzle
    ./homepage
    ./baikal
    ./arr
    ./qbittorrent
    ./vaultwarden
    ./speedtest
    ./immich
    ./plex
    ./overseerr
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
