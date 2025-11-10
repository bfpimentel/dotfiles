{ pkgs, ... }:

{
  imports = [
    ../pkgs.nix
  ];

  environment.systemPackages = with pkgs; [
    # tmux
    zellij
    immich-go

    android-tools
    cargo
    xh
    uv
    redis
    google-cloud-sdk
    nodejs_24
  ];
}
