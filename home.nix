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

  osSpecific =
    {
      darwin ? { },
      linux ? { },
    }:
    if pkgs.stdenv.isDarwin then darwin else linux;
in
{
  home = {
    username = "bruno";
    stateVersion = "25.11";
    homeDirectory = osSpecific {
      darwin = "/Users/bruno";
      linux = "/home/bruno";
    };
  };

  home.file = {
    "Documents/Vial".source = mapAbsolute "misc/vial";
  }
  // mapDotfiles (
    [
      "fish"
      "git"
      "kitty"
      "lazygit"
      "nvim"
      "opencode"
      "ssh"
      "tmux"
    ]
    ++ osSpecific {
      darwin = [ "aerospace" ];
      linux = [ ];
    }
  );

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

  homebrew = osSpecific {
    darwin = {
      taps = [
        {
          name = "jsattler/tap";
          repo = "https://github.com/jsattler/tap.git";
        }
        {
          name = "nikitabobko/tap";
          repo = "https://github.com/nikitabobko/tap.git";
        }
      ];
      formulae = [
        "dockutil"
      ];
      casks = [
        "nikitabobko/tap/aerospace"
        "jsattler/tap/bettercapture"

        "altserver"
        "ankerwork"
        "anydesk"
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
  };
}
