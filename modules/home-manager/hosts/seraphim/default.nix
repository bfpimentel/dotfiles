{ util, ... }:

let
  inherit (util) mapDotfiles;
in
{

  home.file = {
  }
  // mapDotfiles ([
    "aerospace"
    "borders"
    "rift"
    "tuna"
  ]);

  homebrew = {
    taps = [
      {
        name = "nikitabobko/tap";
        repo = "https://github.com/nikitabobko/tap.git";
      }
      {
        name = "jsattler/tap";
        repo = "https://github.com/jsattler/tap.git";
      }
      {
        name = "mikker/tap";
        repo = "https://github.com/mikker/tap.git";
      }
      {
        name = "felixkratz/formulae";
        repo = "https://github.com/felixkratz/formulae.git";
      }
      {
        name = "acsandmann/tap";
        repo = "https://github.com/acsandmann/tap.git";
      }
    ];
    formulae = [
      "acsandmann/tap/rift"
      "felixkratz/formulae/borders"

      "mole"
    ];
    casks = [
      "jsattler/tap/bettercapture"
      "mikker/tap/tuna"

      "kitty"

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
      "lm-studio"
      "moonlight"
      "raycast"
      "shottr"
      "tailscale-app"
      "the-unarchiver"
      "vial"
      "wallspace"
      "xcodes-app"

      "sf-symbols"
      "font-victor-mono-nerd-font"
    ];
  };
}
