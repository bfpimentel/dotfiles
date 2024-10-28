{ pkgs, ... }:

{
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    localsend
    kitty

    python3
    wget
    helix
    nodejs_22

    nil
    lua-language-server
    bash-language-server
    yaml-language-server
    typescript-language-server
    nixfmt-rfc-style
    prettierd

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
