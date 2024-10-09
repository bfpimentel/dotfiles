{ config, ... }:

{
  home.file.".config/helix" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/hosts/solaire/helix/config";
  };
}
