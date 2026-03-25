{ util, ... }:

let
  inherit (util) mapAbsolute mapDotfiles osSpecific;
in
{
  home.file = {
    "Documents/Vial".source = mapAbsolute "misc/vial";
  }
  // mapDotfiles (
    [
      "fish"
      "git"
      "kitty"
      "lazygit"
      "nvim"
      "opencode"
      "tree-sitter"
      "tmux"
    ]
    ++ osSpecific {
      darwin = [
        "aerospace"
        "tuna"
      ];
      linux = [
        "sway"
        "waybar"
        "wofi"
      ];
    }
  );
}
