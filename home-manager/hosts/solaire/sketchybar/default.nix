{ config, ... }:

{
  home.file.".config/sketchybar" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/hosts/solaire/sketchybar/config";
  };
}
