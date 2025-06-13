{ ... }:

let
  configureForGaming = true;
in
{
  imports = [
    ./displaymanager
    ./ollama
    ./restic
    ./steam
    ./sunshine
    ./wireguard
  ];

  services.xserver.enable = true;

  bfmp.services = {
    restic.enable = true;
    ollama.enable = false;
    steam.enable = configureForGaming;
    sunshine.enable = configureForGaming;
    wireguard = {
      enable = false;
      isServer = false;
    };
    displayManager = {
      enable = configureForGaming;
      enableHyprland = true;
    };
  };
}
