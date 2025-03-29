{ pkgs, ... }:

{
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    qrencode

    python3
    wget
    helix
    gradle
    cmake
    argparse

    nodejs_23

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
