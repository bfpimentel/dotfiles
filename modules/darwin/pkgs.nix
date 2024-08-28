{ config, lib, pkgs, ... }:

{
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [ 
    kitty
    eza
    bat
    rbenv
    kdoctor
    fzf
    fd
    gnupg
    neovim
    tmux
    nixd
    cargo
    localsend
    fastfetch
    lazygit
  ];
}
