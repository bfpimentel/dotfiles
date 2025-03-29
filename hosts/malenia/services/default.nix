{ ... }:

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
    ollama.enable = false;
    sunshine.enable = false;
    xserver = {
      enable = true;
      configureHyprland = false;
    };
    wireguard = {
      enable = false;
      isServer = false;
    };
  };
}
