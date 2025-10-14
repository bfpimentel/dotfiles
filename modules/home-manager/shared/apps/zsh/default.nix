{
  config,
  util,
  pkgs,
  ...
}:

{
  programs.zsh = {
    enable = true;
    envExtra = ''
      ZDOTDIR=$HOME/.config/zsh
      source ${pkgs.antidote}/share/antidote/antidote.zsh
    '';
  };

  home.file = util.linkSharedApp config "zsh";
}
