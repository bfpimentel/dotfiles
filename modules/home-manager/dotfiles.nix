{ util, ... }:

let
  inherit (util) mapAbsolute osSpecific;

  mapDotfiles =
    apps:
    builtins.listToAttrs (
      builtins.map (app: {
        name = ".config/${app}";
        value = {
          source = mapAbsolute "dotfiles/${app}";
        };
      }) apps
    );
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
      "tree-sitter"
      "tmux"
    ]
    ++ osSpecific {
      darwin = [
        "aerospace"
        "tuna"
      ];
      linux = [
        "sunshine"
        "sway"
        "waybar"
        "wofi"
        "mako"
        "xdg-desktop-portal"
        "xdg-desktop-portal-wlr"
        "eww"
      ];
    }
  )
  // osSpecific {
    linux = {
      ".local/share/applications".source = mapAbsolute "dotfiles/applications";
    };
  };
}
