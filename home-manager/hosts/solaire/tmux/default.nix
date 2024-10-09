{ config, ... }:

{
  programs.tmux.enable = true;

  home.file.".config/tmux" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/hosts/solaire/tmux/config";
  };
}
