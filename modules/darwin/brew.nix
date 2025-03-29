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
      "hcxtools"
      "cocoapods"
      # "ykman"
      # "switchaudio-osx"
      # "nowplaying-cli"
      # "sketchybar"
      # "borders"
    ];

    taps = [
      "nikitabobko/tap"
      "felixkratz/formulae"
    ];

    casks = [
      { name = "xcodes"; greedy = true; }
      { name = "ghostty"; greedy = true; }
      { name = "localsend"; greedy = true; }
      { name = "wifiman"; greedy = true; }
      { name = "linearmouse"; greedy = true; }
      { name = "shottr"; greedy = true; }
      { name = "raspberry-pi-imager"; greedy = true; }
      { name = "brave-browser"; greedy = true; }
      { name = "hiddenbar"; greedy = true; }
      { name = "bitwarden"; greedy = true; }
      # { name = "notchnook"; greedy = true; }
      # { name = "raycast"; greedy = true; }
      { name = "pearcleaner"; greedy = true; }
      { name = "kap"; greedy = true; }
      { name = "aerospace"; greedy = true; }
      { name = "zen-browser"; greedy = true; }
      { name = "the-unarchiver"; greedy = true; }
      { name = "font-space-mono-nerd-font"; greedy = true; }
      # { name = "sf-symbols"; greedy = true; }
      # { name = "font-sf-pro"; greedy = true; }
      # { name = "font-sf-mono"; greedy = true; }
      # { name = "font-sketchybar-app-font"; greedy = true; }
    ];
  };
}
