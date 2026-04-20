{ ... }:

{
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
    ];
    formulae = [
      "mole"
    ];
    casks = [
      "nikitabobko/tap/aerospace"
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
      "xcodes-app"

      "sf-symbols"
      "font-victor-mono-nerd-font"
    ];
  };
}
