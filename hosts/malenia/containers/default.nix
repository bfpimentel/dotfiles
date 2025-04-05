{ ... }:

let
  enableAIStack = false;
  enableGlanceDashboard = true;
in
{
  imports = [
    ./apprise
    ./arr
    ./audiobookshelf
    ./authentik
    ./baikal
    ./beszel
    ./ddns
    ./dozzle
    ./freshrss
    ./glance
    ./hoarder
    ./homepage
    ./immich
    ./invoke
    ./it-tools
    ./n8n
    ./ntfy
    ./ollama-webui
    ./overseerr
    ./paperless
    ./plex
    ./qbittorrent
    ./speedtest
    ./stirling-pdf
    ./tautulli
    ./traefik
    ./vaultwarden
    ./whisper
  ];

  virtualisation = {
    containers.enable = true;
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  networking.firewall.interfaces."podman+".allowedUDPPorts = [
    53
    5353
  ];

  bfmp.containers = {
    apprise.enable = true;
    arr.enable = true;
    audiobookshelf.enable = true;
    authentik.enable = true;
    baikal.enable = true;
    beszel.enable = true;
    ddns.enable = false;
    dozzle.enable = true;
    freshrss.enable = true;
    glance.enable = enableGlanceDashboard;
    hoarder.enable = true;
    homepage.enable = !enableGlanceDashboard;
    immich.enable = true;
    invoke.enable = false;
    it-tools.enable = true;
    n8n.enable = false;
    ntfy.enable = false;
    ollama-webui.enable = enableAIStack;
    overseerr.enable = true;
    paperless.enable = false;
    plex.enable = true;
    qbittorrent.enable = true;
    speedtest.enable = true;
    stirling-pdf.enable = true;
    tautulli.enable = true;
    traefik.enable = true;
    vaultwarden.enable = true;
    whisper.enable = enableAIStack;
  };
}
