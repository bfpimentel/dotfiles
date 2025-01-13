{ ... }:

{
  imports = [
    ./restic
    ./wireguard
    ./plex
    ./xserver
    ./sunshine
    # ./jellyfin
    # ./ollama
  ];

  programs.sunshine.enable = false;
}
