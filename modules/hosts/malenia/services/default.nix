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
    ./tailscale
    ./wireguard
  ];

  bfmp.services = {
    displayManager = {
      enable = configureForGaming;
      de = "plasma";
    };
    gaming.enable = configureForGaming;
    restic.enable = true;
    streaming.enable = configureForGaming;
    wireguard = {
      enable = false;
      isServer = false;
    };
    tailscale.enable = true;
  };
}
