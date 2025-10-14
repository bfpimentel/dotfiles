{ util, config, ... }:

{
  programs.ghostty.enable = true;

  home.file = util.linkHostApp config "ghostty";
}
