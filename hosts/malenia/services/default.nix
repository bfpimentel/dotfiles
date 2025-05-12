{ ... }:

let
  configureForGaming = true;
in
{
  imports = [
    ./hyprland
    ./ollama
    ./restic
    ./sunshine
    ./wireguard
    ./xserver
  ];

  bfmp.services = {
    restic.enable = true;
    ollama.enable = false;
    sunshine.enable = configureForGaming;
    hyprland.enable = configureForGaming;
    xserver.enable = true;
    wireguard = {
      enable = false;
      isServer = false;
    };
  };
}
