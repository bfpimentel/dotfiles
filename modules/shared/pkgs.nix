{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    node2nix

    antidote
    direnv
    gnupg
    fzf
    ripgrep
    fastfetch

    git
    btop
    qrencode
    nmap
    wget
    # liborbispkg-pkgtool
  ];
}
