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

          "brave-browser"
          "shottr"
          "kap"
          "pearcleaner"
          "ankerwork"
          "loom"

          "ghostty"
          "bruno"
          "http-toolkit"

          "bambu-studio"
          "autodesk-fusion"

          "moonlight"
          "crossover"
          "anydesk"

          "font-victor-mono-nerd-font"
          "sf-symbols"
        ];
  };
}
