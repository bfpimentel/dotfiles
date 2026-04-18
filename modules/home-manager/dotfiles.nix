{ util, ... }:

let
  inherit (util) mapAbsolute osSpecific mapDotfiles;
in
{
  home.file = {
    "Documents/Vial".source = mapAbsolute "misc/vial";
    "Documents/Wallpapers".source = mapAbsolute "misc/wallpapers";
  }
  // mapDotfiles (
    [
      "fish"
      "git"
      "kitty"
      "lazygit"
      "nvim"
      "opencode"
      "tmux"
    ]
    ++ osSpecific {
      darwin = [
        "aerospace"
        "tuna"
      ];
      linux = [
        "hypr"
        "sunshine"
        "quickshell"
      ];
    }
  )
  // osSpecific {
    linux = {
      ".local/share/applications".source = mapAbsolute "dotfiles/applications";
    };
    darwin = { };
  };
}
