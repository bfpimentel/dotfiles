{ ... }:

let
  configureForGaming = true;
in
{
  imports = [
    ./displaymanager
    ./gaming
    ./ollama
    ./restic
    ./streaming
    ./wireguard
  ];

  bfmp.services = {
    displayManager = {
      enable = configureForGaming;
      enableHyprland = false;
    };
    gaming.enable = configureForGaming;
    ollama.enable = false;
    restic.enable = true;
    streaming.enable = configureForGaming;
    wireguard = {
      enable = false;
      isServer = false;
    };
  };
}
