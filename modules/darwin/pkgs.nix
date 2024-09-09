{ pkgs, ... }:

{
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    python3
    wget
    helix
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
    nil
    nixfmt-rfc-style
    cargo
    localsend
    fastfetch
    lazygit
  ];
}
