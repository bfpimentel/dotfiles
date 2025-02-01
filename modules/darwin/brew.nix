{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };

    brews = [
      "lua"
      "ripgrep"
      "sketchybar"
      "libpcap"
      "hcxtools"
      "xz"
      "ykman"
      "switchaudio-osx"
      "nowplaying-cli"
      "borders"
    ];

    taps = [
      "nikitabobko/tap"
      "felixkratz/formulae"
    ];

    casks = [
      { name = "zoom"; greedy = true; }
      { name = "xcodes"; greedy = true; }
      { name = "ghostty"; greedy = true; }
      { name = "moonlight"; greedy = true; }
      { name = "localsend"; greedy = true; }
      { name = "balenaetcher"; greedy = true; }
      { name = "wifiman"; greedy = true; }
      { name = "vial"; greedy = true; }
      { name = "linearmouse"; greedy = true; }
      { name = "legcord"; greedy = true; }
      { name = "shottr"; greedy = true; }
      { name = "raspberry-pi-imager"; greedy = true; }
      { name = "brave-browser"; greedy = true; }
      { name = "hiddenbar"; greedy = true; }
      { name = "notchnook"; greedy = true; }
      { name = "raycast"; greedy = true; }
      { name = "psst"; greedy = true; }
      { name = "pearcleaner"; greedy = true; }
      { name = "kap"; greedy = true; }
      { name = "aerospace"; greedy = true; }
      { name = "zen-browser"; greedy = true; }
      { name = "the-unarchiver"; greedy = true; }
      { name = "firefox"; greedy = true; }
      { name = "thunderbird@beta"; greedy = true; }

      { name = "sf-symbols"; greedy = true; }
      { name = "font-sf-pro"; greedy = true; }
      { name = "font-sf-mono"; greedy = true; }
      { name = "font-space-mono-nerd-font"; greedy = true; }
      { name = "font-sketchybar-app-font"; greedy = true; }
    ];

    masApps = { 
      "wireguard" = 1451685025; 
    };
  };
}
