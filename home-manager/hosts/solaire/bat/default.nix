{ config, ... }:

{
  home.file.".config/bat" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/hosts/solaire/bat/config";
  };
}
