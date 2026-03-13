{
  config,
  pkgs,
  ...
}:

let
  mapAbsolute =
    path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/${path}";

  mapDotfiles =
    apps:
    builtins.listToAttrs (
      builtins.map (app: {
        name = ".config/${app}";
        value = {
          source = mapAbsolute "dotfiles/${app}";
        };
      }) apps
    );

  ifDarwin = value: (if pkgs.stdenv.isDarwin then value else [ ]);
in
{
  home = {
    username = "bruno";
    homeDirectory = "/Users/bruno";
    stateVersion = "25.11";
  };

  home.file = {
    "Documents/Vial".source = mapAbsolute "misc/vial";
  }
  // mapDotfiles [
    "fish"
    "git"
    "kitty"
    "lazygit"
    "nvim"
    "opencode"
    "ssh"
    "tmux"
  ]
  // ifDarwin mapDotfiles [
    "aerospace"
  ];

  home.packages =
    with pkgs;
    [
      nh

      fish
      tmux

      lua

      direnv

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
    ++ ifDarwin (
      with pkgs;
      [
        dockutil
        xcodes
        aerospace
      ]
    );

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      tree-sitter

      ruff

      nil
      nixfmt

      lua-language-server
      stylua

      bash-language-server
      beautysh

      yaml-language-server
      yamlfmt

      oxlint
      prettierd
      typescript-language-server
      tailwindcss-language-server
      vscode-langservers-extracted

      fish-lsp
    ];
  };

  homebrew = {
    taps = ifDarwin [
      {
        name = "jsattler/tap";
        repo = "https://github.com/jsattler/tap.git";
      }
    ];
    casks = ifDarwin [
      "altserver"
      "ankerwork"
      "anydesk"
      "bettercapture"
      "betterdisplay"
      "bruno"
      "eqmac"
      "helium-browser"
      "hiddenbar"
      "http-toolkit"
      "linearmouse"
      "moonlight"
      "pearcleaner"
      "raycast"
      "shottr"
      "tailscale-app"
      "the-unarchiver"
      "vial"
      "xcodes-app"

      "sf-symbols"
      "font-victor-mono-nerd-font"
    ];
  };
}
