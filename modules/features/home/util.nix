{ ... }:

{
  config.bfmp.hm.sharedModules = [
    (
      { config, ... }:
      let
        mapAbsolute =
          path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/${path}";

        mapDotfiles =
          apps:
          builtins.listToAttrs (
            map (app: {
              name = ".config/${app}";
              value = {
                source = mapAbsolute "dotfiles/${app}";
              };
            }) apps
          );
      in
      {
        _module.args.util = {
          inherit mapAbsolute mapDotfiles;
        };
      }
    )
  ];
}
