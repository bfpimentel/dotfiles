{ config, username, ... }:

{
  programs.zsh = {
    enable = true;
    envExtra = ''
      ZDOTDIR="/Users/${username}/.config/zsh"
    '';
  };

  home.file.".config/zsh" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
