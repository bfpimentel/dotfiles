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
    ./sunshine
    ./wireguard
  ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  bfmp.services = {
    restic.enable = true;
    gaming.enable = configureForGaming;
    ollama.enable = false;
    sunshine.enable = configureForGaming;
    wireguard = {
      enable = false;
      isServer = false;
    };
    displayManager = {
      enable = configureForGaming;
      enableHyprland = false;
    };
  };
}
