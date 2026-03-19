{ util, ... }:

let
  inherit (util) osSpecific;
in
{
  homebrew = osSpecific {
    darwin = {
      taps = [
        {
          name = "jsattler/tap";
          repo = "https://github.com/jsattler/tap.git";
        }
        {
          name = "nikitabobko/tap";
          repo = "https://github.com/nikitabobko/tap.git";
        }
      ];
      formulae = [
        "dockutil"
        "mole"
      ];
      casks = [
        "nikitabobko/tap/aerospace"
        "jsattler/tap/bettercapture"

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
  };
}
