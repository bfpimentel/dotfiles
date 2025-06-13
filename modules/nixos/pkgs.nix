{
  pkgs,
  inputs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    unzip
    fzf
    ripgrep
    pciutils
    tcpdump
    lm_sensors
    lazygit
    wireguard-tools
    inetutils
    ncdu

    smartmontools
    memtester

    clang-tools
    gcc
    cargo
    nodejs_22

    podman-tui
    podman-compose

    inputs.agenix.packages."${system}".default
    inputs.home-manager.packages."${system}".default
  ];
}
