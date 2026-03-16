{ config, pkgs, ... }:

let
  mapAbsolute =
    path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/${path}";

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

  osSpecific =
    {
      darwin ? { },
      linux ? { },
    }:
    if pkgs.stdenv.isDarwin then darwin else linux;
in
{
  _module.args.util = {
    inherit mapAbsolute mapDotfiles osSpecific;
  };
}
