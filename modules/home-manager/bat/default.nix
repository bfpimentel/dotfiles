{ config, ... }:

{
  home.file.".config/bat" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/home-manager/bat/config";
  };
}
