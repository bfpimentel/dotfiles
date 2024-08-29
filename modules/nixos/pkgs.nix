{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    podman-tui
    podman-compose
    nixfmt-rfc-style
    inputs.agenix.packages."${system}".default
    inputs.home-manager.packages."${system}".default
  ];

  programs.zsh.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];
}
