{
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
    unzip
    eza
    fzf
    fd
    ripgrep
    pciutils
    tcpdump
    lm_sensors
    lazygit
    oh-my-posh
    wireguard-tools
    inetutils
    lemonade

    clang-tools
    gcc
    cargo
    nodejs_22

    podman-tui
    podman-compose

    inputs.agenix.packages."${system}".default
    inputs.home-manager.packages."${system}".default
  ];

  programs.zsh.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];
}
