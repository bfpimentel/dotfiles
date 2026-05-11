{ inputs, ... }:

{
  config.bfmp.hm.hosts.seraphim.modules = [
    inputs.homebrew.homeManagerModules.default
    (
      { ... }:
      {
        homebrew = {
          taps = [
            {
              name = "nikitabobko/tap";
              repo = "https://github.com/nikitabobko/tap.git";
            }
            {
              name = "mikker/tap";
              repo = "https://github.com/mikker/tap.git";
            }
            {
              name = "felixkratz/formulae";
              repo = "https://github.com/felixkratz/formulae.git";
            }
          ];

          formulae = [
            "felixkratz/formulae/borders"

            "mole"
          ];

          casks = [
            "mikker/tap/tuna"
            "nikitabobko/tap/aerospace"

            "altserver"
            "ankerwork"
            "anydesk"
            "betterdisplay"
            "bruno"
            "codex-app"
            "eqmac"
            "helium-browser"
            "hiddenbar"
            "http-toolkit"
            "kitty"
            "linearmouse"
            "lm-studio"
            "moonlight"
            "pearcleaner"
            "shottr"
            "the-unarchiver"
            "vial"
            "wallspace"
            "xcodes-app"

            "sf-symbols"
            "font-victor-mono-nerd-font"
            "font-iosevka-nerd-font"
          ];
        };
      }
    )
  ];
}
