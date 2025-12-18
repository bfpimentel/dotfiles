{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };

    masApps = {
      "quickdrop" = 6740147178;
    };

    brews = [
      "lua"
      "ripgrep"
      "libpcap"
      "xz"
      "redis"
      "postgresql@17"
    ];

    taps = [
      "nikitabobko/tap"
      "krtirtho/apps"
    ];

    casks =
      builtins.map
        (cask: {
          name = cask;
          greedy = true;
        })
        [
          "xcodes-app"
          "betterdisplay"
          "linearmouse"
          "hiddenbar"
          "the-unarchiver"
          "aerospace"
          "raycast"

          "brave-browser"
          "helium-browser"
          "shottr"
          "kap"
          "pearcleaner"
          "ankerwork"
          "tailscale-app"
          # "loom"

          "ghostty"
          "bruno"
          "http-toolkit"
          "macfuse"

          "bambu-studio"
          # "autodesk-fusion"

          "moonlight"
          "crossover"
          "anydesk"

          "font-victor-mono-nerd-font"
          "font-commit-mono-nerd-font"
          "sf-symbols"
        ];
  };
}
