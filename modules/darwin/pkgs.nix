{ pkgs, ... }:

{
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    python3
    wget
    helix
    kitty
    eza
    bat
    oh-my-posh
    rbenv
    kdoctor
    fzf
    fd
    gnupg
    tmux
    nil
    nixfmt-rfc-style
    cargo
    localsend
    fastfetch
    lazygit
  ];
}
