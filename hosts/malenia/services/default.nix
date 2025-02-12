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
    ./ollama
  ];

  bfmp.services = {
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
