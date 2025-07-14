{
  pkgs,
  inputs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default
    inputs.home-manager.packages."${system}".default

    nh

    antidote
    direnv
    gnupg
    fzf
    ripgrep
    fastfetch

    git
    btop
    qrencode
    nmap
    wget
    pciutils
    tcpdump
    lm_sensors
    wireguard-tools
    inetutils
    ncdu
    # liborbispkg-pkgtool

    python3
  ];
}
