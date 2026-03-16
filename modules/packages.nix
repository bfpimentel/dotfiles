{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nh

    fish
    tmux

    lua

    direnv

    lazygit
    gnupg
    ripgrep
    libpcap
    fzf
    wget

    opencode

    kitty
  ];
}
