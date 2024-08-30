{ config, ... }:

{
  programs.zsh = {
    enable = true;
    envExtra = ''
    ZDOTDIR=".config/zsh"
    '';
  };

  home.file.".config/zsh" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
