{ config, ... }:

{
  home.file.".config/kitty" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/hosts/solaire/kitty/config";
  };
}
