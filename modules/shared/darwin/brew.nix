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
      "wireguard" = 1451685025;
      "quickdrop" = 6740147178;
    };

    brews = [
      "lua"
      "ripgrep"
      "libpcap"
      "xz"
      "redis"
      # "cocoapods"
      # "sketchybar"
      # "borders"
    ];

    taps = [
      "nikitabobko/tap"
      "felixkratz/formulae"
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

          "brave-browser"
          "shottr"
          "kap"
          "pearcleaner"
          "ankerwork"
          "loom"

          "ghostty"
          "bruno"
          "http-toolkit"
          "postgres-unofficial"

          "bambu-studio"
          "autodesk-fusion"

          "moonlight"
          "crossover"
          "anydesk"

          "font-victor-mono-nerd-font"
          "font-space-mono-nerd-font"
          "font-maple-mono-nf"
          "font-sf-mono-nerd-font-ligaturized"
          # "font-sketchybar-app-font"
        ];
  };
}
