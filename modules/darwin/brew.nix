{ config, lib, pkgs, ... }:

{
  homebrew = {
    enable = true;
    
    global = {
      autoUpdate = true;
    };

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
    ];

    taps = [
      "nikitabobko/tap"
      "felixkratz/formulae"
    ];

    casks = [ 
      "xcodes" 
      "floorp" 
      "balenaetcher"  
      "vial"
      "thunderbird"
      "raspberry-pi-imager"
      "vlc"
      "linearmouse"
      "shottr"
      "hiddenbar"
      "notchnook"
      "raycast"
      "psst"
      "obsidian"
      "obs"
      "zoom"
      "altserver"
      "pearcleaner"
      "kap"
      "aerospace"
      "brave-browser@beta"
      "firefox@nightly"
      "font-space-mono-nerd-font"
    ];
  };
}
