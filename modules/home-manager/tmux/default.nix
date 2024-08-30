{ config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.file.".config/tmux" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
