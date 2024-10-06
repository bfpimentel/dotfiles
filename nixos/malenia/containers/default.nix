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
    ./jellyseerr
    ./tautulli
    ./authentik
    ./ntfy
    ./ollama-webui
    ./whisper
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
