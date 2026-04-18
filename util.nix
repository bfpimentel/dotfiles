{ config, pkgs, ... }:

let
  mapAbsolute =
    path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/${path}";

  osSpecific =
    {
      darwin ? { },
      linux ? { },
    }:
    if pkgs.stdenv.isDarwin then darwin else linux;

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
  _module.args.util = {
    inherit mapAbsolute osSpecific mapDotfiles;
  };
}
