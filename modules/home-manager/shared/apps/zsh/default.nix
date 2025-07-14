{
  config,
  homeManagerConfig,
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

  home.file.".config/zsh".source = homeManagerConfig.linkSharedApp config "zsh";
}
