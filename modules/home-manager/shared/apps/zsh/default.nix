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
      source ${pkgs.antidote}/share/antidote/antidote.zsh

      ZDOTDIR=$HOME/.config/zsh

      PATH=$PATH:${pkgs.aircrack-ng}/bin
    '';
  };

  home.file = util.linkSharedApp config "zsh";
}
