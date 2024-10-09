{ config, ... }:

{
  home.file.".config/aerospace" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/hosts/solaire/aerospace/config";
  };
}
