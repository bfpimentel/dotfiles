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
    # ./jellyfin
    # ./ollama
  ];

  bfmp.services = {
    sunshine.enable = enableSunshine;
    xserver = {
      enable = true;
      configureForSunshine = enableSunshine;
    };
  };
}
