{ util, ... }:

let
  inherit (util) osSpecific;
in
{
  homebrew = osSpecific {
    darwin = {
      formulae = [
        "dockutil"
        "mole"
      ];
      casks = [
        "nikitabobko/tap/aerospace"
        "jsattler/tap/bettercapture"
        "mikker/tap/tuna"

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
