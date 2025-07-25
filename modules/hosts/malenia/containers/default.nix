{ ... }:

{
  imports = [
    ./actualbudget
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
    ./invoke
    ./it-tools
    ./jellyfin
    ./jellyseerr
    ./ollama-webui
    ./papra
    ./pocket-id
    ./qbittorrent
    ./speedtest
    ./stirling-pdf
    ./tinyauth
    ./traefik
    ./vaultwarden
    ./whisper
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
    };
  };

  networking.firewall.interfaces."docker+".allowedUDPPorts = [
    53
    5353
  ];

  bfmp.containers =
    let
      enableAIStack = false;
      enableGlanceDashboard = true;
    in
    {
      actualbudget.enable = true;
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
      invoke.enable = enableAIStack;
      it-tools.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
      ollama-webui.enable = enableAIStack;
      papra.enable = true;
      pocket-id.enable = true;
      qbittorrent.enable = true;
      speedtest.enable = true;
      stirling-pdf.enable = true;
      tinyauth.enable = true;
      traefik.enable = true;
      vaultwarden.enable = false;
      whisper.enable = enableAIStack;
    };
}
