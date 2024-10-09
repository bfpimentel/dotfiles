{ config, ... }:

{
  home.file.".config/sketchybar" = {
    source = config.lib.file.mkOutOfStoreSymlink (./. + "/config");
  };
}
