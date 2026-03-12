{ config, pkgs, ... }:

let
  mapApps =
    apps:
    builtins.listToAttrs (
      builtins.map (app: {
        name = ".config/${app}";
        value = {
          source = ./dotfiles/${app};
          recursive = true;
        };
      }) apps
    );
in
{
  home = {
    username = "bruno";
    homeDirectory = "/Users/bruno";
    stateVersion = "25.11";
  };

  home.file =
    mapApps [
      "git"
      "kitty"
      "lazygit"
      "nvim"
      "opencode"
      "ssh"
      "tmux"
      "zsh"
    ]
    // (
      if pkgs.stdenv.isDarwin then
        mapApps [
          "aerospace"
        ]
      else
        mapApps [ ]
    );

  home.packages =
    with pkgs;
    [
      nh
      nil
      nixfmt

      direnv

      zplug
      tmux

      lua

      lazygit
      gnupg
      ripgrep
      libpcap
      eza
      fzf
      wget

      opencode

      kitty
    ]
    ++ (
      if pkgs.stdenv.isDarwin then
        with pkgs;
        [
          dockutil
          xcodes
          # vial
          aerospace
        ]
      else
        [
        ]
    );

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = "${config.home.homeDirectory}/.config/zsh";
    envExtra = ''
      export ZDOTDIR=${config.home.homeDirectory}/.config/zsh
      source ${pkgs.zplug}/share/zplug/init.zsh
    '';
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      tree-sitter

      ruff

      lua-language-server
      stylua

      bash-language-server
      beautysh

      yaml-language-server
      yamlfmt

      oxlint
      oxfmt
      typescript-language-server
      tailwindcss-language-server
      vscode-langservers-extracted
    ];
  };
}
