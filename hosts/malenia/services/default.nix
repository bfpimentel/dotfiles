{ ... }:

let
  enableSunshine = true;
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
    sunshine.enable = enableSunshine;
    xserver = {
      enable = true;
      configureForSunshine = enableSunshine;
    };
    wireguard = {
      enable = true;
      isServer = true;
    };
  };
}
