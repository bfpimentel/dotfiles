{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim

    qrencode
    android-tools
    nmap

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
