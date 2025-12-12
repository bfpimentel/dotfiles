{ ... }:

let
  configureForGaming = true;
in
{
  imports = [
    ./displaymanager
    ./gaming
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
    restic.enable = true;
    streaming.enable = configureForGaming;
    wireguard = {
      enable = false;
      isServer = false;
    };
  };
}
