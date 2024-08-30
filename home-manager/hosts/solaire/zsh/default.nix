{ config, ... }:

{
  programs.zsh = {
    enable = true;
    # dotDir = ".config/zsh";
    envExtra = ''
    ZDOTDIR=".config/zsh"
    '';
  };

  home.file.".config/zsh" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
