{ pkgs, ... }:

{
  imports = [
    ../pkgs.nix
  ];

  environment.systemPackages = with pkgs; [
    nixos-rebuild-ng

    tmux
    zellij
    immich-go

    android-tools
    pstree
    cargo
    xh
    uv
    redis
    google-cloud-sdk
    nodejs_24
    pnpm

    opencode
  ];
}
