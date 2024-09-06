{ pkgs, vars, ... }:

let
  podmanBin = "${pkgs.podman}/bin/podman";
in
{
  imports = [
    ./traefik
    ./dozzle
    ./homepage
    ./baikal
    ./vaultwarden
    ./speedtest
    #./arr
    #./qbittorrent
    #./immich
    #./plex
    #./overseerr
    #./tautulli
  ];

  # systemd.services."podman-network-public" = {
  #   serviceConfig.Type = "oneshot";
  #   script = ''
  #     ${podmanBin} network inspect public > /dev/null 2>&1 || ${podmanBin} network create public --interface-name=${vars.networkInterface}
  #   '';
  # };

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
