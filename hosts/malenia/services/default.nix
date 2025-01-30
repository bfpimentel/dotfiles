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
    ollama.enable = false;
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
