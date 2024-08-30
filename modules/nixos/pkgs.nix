{
  pkgs,
  inputs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    unzip
    gcc
    fzf
    fd
    cargo
    nodejs_22
    nil
    bash-language-server
    yaml-language-server
    podman-tui
    podman-compose
    nixfmt-rfc-style
    inputs.agenix.packages."${system}".default
    inputs.home-manager.packages."${system}".default
  ];

  programs.zsh.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];
}
