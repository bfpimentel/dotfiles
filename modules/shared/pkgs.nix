{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
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
    iperf
  ];
}
