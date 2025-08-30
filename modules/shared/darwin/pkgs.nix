{ pkgs, ... }:

{
  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    opencode

    antidote
    direnv
    gnupg
    fzf
    ripgrep
    fastfetch

    btop
    qrencode
    nmap
    wget

    android-tools
    cargo

    xh

    uv
    google-cloud-sdk
    redis
  ];
}
