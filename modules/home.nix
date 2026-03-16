{ util, ... }:

let
  inherit (util) osSpecific;
in
{
  home = {
    username = "bruno";
    stateVersion = "25.11";
    homeDirectory = osSpecific {
      darwin = "/Users/bruno";
      linux = "/home/bruno";
    };
  };

  programs.home-manager.enable = true;
}
