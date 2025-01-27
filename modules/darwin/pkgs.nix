{ pkgs, ... }:

{
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    qrencode

    python3
    wget
    helix
    nodejs_22
    gradle

    argparse
    python313Packages.fontforge

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
