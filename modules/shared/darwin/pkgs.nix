{ pkgs, ... }:

{
  imports = [
    ../pkgs.nix
  ];

  environment.systemPackages = with pkgs; [
    # tmux
    zellij
    immich-go
    aircrack-ng

    android-tools
    cargo
    xh
    uv
    redis
    google-cloud-sdk
    nodejs_24
  ];
}
