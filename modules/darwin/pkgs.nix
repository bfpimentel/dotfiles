{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim

    qrencode
    android-tools

    python3
    helix
    gradle
    cmake
    argparse
    cargo
    direnv

    nodejs_24
    zulu17

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
