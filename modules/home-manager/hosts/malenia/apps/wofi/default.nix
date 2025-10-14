{ util, config, ... }:

{
  programs.wofi.enable = true;

  home.file = util.linkHostApp config "wofi";
}
