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
      "borders"
      "libpcap"
      "hcxtools"
      "xz"
      "ykman"
    ];

    taps = [
      "nikitabobko/tap"
      "felixkratz/formulae"
    ];

    casks = [
      "xcodes"
      "balenaetcher"
      "vial"
      "linearmouse"
      "shottr"
      "hiddenbar"
      "notchnook"
      "raycast"
      "psst"
      "altserver"
      "pearcleaner"
      "kap"
      "aerospace"
      "zen-browser"
      "thunderbird@beta"
      "font-space-mono-nerd-font"
    ];
  };
}
