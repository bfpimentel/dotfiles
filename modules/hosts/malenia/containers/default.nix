{ ... }:

{
  imports = [
    ./apprise
    ./arr
    ./audiobookshelf
    ./baikal
    ./beszel
    ./dawarich
    ./ddns
    ./dozzle
    ./freshrss
    ./glance
    ./grocy
    ./hoarder
    ./homepage
    ./immich
    ./it-tools
    ./jellyfin
    ./jellyseerr
    ./ollama
    ./orcaslicer
    ./papra
    ./pocket-id
    ./qbittorrent
    ./speedtest
    ./stirling-pdf
    ./tinyauth
    ./traefik
    ./vaultwarden
  ];

  virtualisation = {
    containers.enable = true;
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      autoPrune = {
        enable = true;
        dates = "daily";
        flags = [ "--all" ];
      };
    };
  };

  networking.firewall.interfaces."docker+".allowedUDPPorts = [
    53
    5353
  ];

  bfmp.containers =
    let
      enableGlanceDashboard = true;
    in
    {
      apprise.enable = true;
      arr.enable = true;
      audiobookshelf.enable = true;
      baikal.enable = true;
      beszel.enable = true;
      dawarich.enable = true;
      ddns.enable = false;
      dozzle.enable = true;
      freshrss.enable = true;
      glance.enable = enableGlanceDashboard;
      grocy.enable = true;
      hoarder.enable = true;
      homepage.enable = !enableGlanceDashboard;
      immich.enable = true;
      it-tools.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
      ollama.enable = true;
      orcaslicer.enable = true;
      papra.enable = true;
      pocket-id.enable = true;
      qbittorrent.enable = true;
      speedtest.enable = true;
      stirling-pdf.enable = true;
      tinyauth.enable = true;
      traefik.enable = true;
      vaultwarden.enable = false;
    };
}
