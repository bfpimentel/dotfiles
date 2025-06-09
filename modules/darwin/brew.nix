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
    };

    brews = [
      "lua"
      "ripgrep"
      "libpcap"
      "xz"
      "cocoapods"
      "immich-go"
      # "ykman"
      # "switchaudio-osx"
      # "nowplaying-cli"
      # "sketchybar"
      # "borders"
    ];

    taps = [
      "nikitabobko/tap"
      "felixkratz/formulae"
      "krtirtho/apps"
    ];

    casks = [
      { name = "xcodes"; greedy = true; }
      { name = "ghostty"; greedy = true; }
      { name = "anydesk"; greedy = true; }
      { name = "zoom"; greedy = true; }
      { name = "ankerwork"; greedy = true; }
      { name = "insomnia"; greedy = true; }
      { name = "balance-lock"; greedy = true; }
      { name = "linearmouse"; greedy = true; }
      { name = "shottr"; greedy = true; }
      { name = "raspberry-pi-imager"; greedy = true; }
      { name = "private-internet-access"; greedy = true; }
      { name = "brave-browser"; greedy = true; }
      { name = "hiddenbar"; greedy = true; }
      { name = "bitwarden"; greedy = true; }
      { name = "moonlight"; greedy = true; }
      { name = "pearcleaner"; greedy = true; }
      { name = "kap"; greedy = true; }
      { name = "aerospace"; greedy = true; }
      { name = "http-toolkit"; greedy = true; }
      { name = "the-unarchiver"; greedy = true; }
      { name = "android-studio-preview@beta"; greedy = true; }
      # { name = "zen-browser"; greedy = true; }
      # { name = "notchnook"; greedy = true; }
      # { name = "raycast"; greedy = true; }

      { name = "font-space-mono-nerd-font"; greedy = true; }
      # { name = "sf-symbols"; greedy = true; }
      # { name = "font-sf-pro"; greedy = true; }
      # { name = "font-sf-mono"; greedy = true; }
      # { name = "font-sketchybar-app-font"; greedy = true; }
    ];
  };
}
