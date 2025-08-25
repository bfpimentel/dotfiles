{ pkgs, ... }:

{
  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    nh

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
  ];
}
