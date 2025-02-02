{ ... }:

let
  enableSunshine = false;
in
{
  imports = [
    ./xserver
    ./sunshine
    ./restic
    ./wireguard
    ./plex
    ./jellyfin
    ./ollama
  ];

  bfmp.services = {
    plex.enable = true;
    jellyfin.enable = false;
    restic.enable = true;
    ollama.enable = true;
    sunshine.enable = true;
    xserver = {
      enable = true;
      configureHyprland = true;
      configureForSunshine = enableSunshine;
    };
    wireguard = {
      enable = true;
      isServer = true;
    };
  };
}
