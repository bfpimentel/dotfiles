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
    # liborbispkg-pkgtool

    btop

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

    clang-tools
    gcc
    cargo
    nodejs_22

    inputs.agenix.packages."${system}".default
    inputs.home-manager.packages."${system}".default
  ];
}
