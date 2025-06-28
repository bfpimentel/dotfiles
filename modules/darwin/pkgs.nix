{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nh

    neovim

    btop
    qrencode
    nmap

    android-tools

    python3
    cmake
    argparse
    cargo
    direnv

    antigen
    wget
    kdoctor
    ripgrep
    fzf
    gnupg
    fastfetch
    lazygit
  ];
}
