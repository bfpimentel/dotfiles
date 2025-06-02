{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim

    qrencode
    android-tools

    python3
    wget
    helix
    gradle
    cmake
    argparse

    nodejs_24
    zulu17

    ripgrep
    eza
    bat
    oh-my-posh
    rbenv
    kdoctor
    fzf
    fd
    gnupg
    tmux
    cargo
    fastfetch
    lazygit
  ];
}
