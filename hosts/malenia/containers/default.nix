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
    ./deluge
    ./dozzle
    ./freshrss
    ./glance
    ./grocy
    ./hoarder
    ./homepage
    ./immich
    ./invoke
    ./it-tools
    ./n8n
    ./ollama-webui
    ./overseerr
    ./pingvin
    ./plex
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
    deluge.enable = true;
    dozzle.enable = true;
    freshrss.enable = true;
    glance.enable = enableGlanceDashboard;
    grocy.enable = true;
    hoarder.enable = true;
    homepage.enable = !enableGlanceDashboard;
    immich.enable = true;
    invoke.enable = enableAIStack;
    it-tools.enable = true;
    n8n.enable = true;
    ollama-webui.enable = enableAIStack;
    overseerr.enable = true;
    pingvin.enable = true;
    plex.enable = true;
    speedtest.enable = true;
    stirling-pdf.enable = true;
    tautulli.enable = true;
    traefik.enable = true;
    vaultwarden.enable = false;
    whisper.enable = enableAIStack;
  };
}
