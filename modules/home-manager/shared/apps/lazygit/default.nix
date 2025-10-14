{ util, config, ... }:

{
  programs.lazygit.enable = true;

  home.file = util.linkSharedApp config "lazygit";
}
