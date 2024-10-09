{ config, ... }:

{
  home.file.".config/lazygit" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/home-manager/lazygit/config";
  };
}
