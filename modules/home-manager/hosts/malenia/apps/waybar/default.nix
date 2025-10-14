{ util, config, ... }:

{
  programs.waybar.enable = true;

  home.file = util.linkHostApp config "waybar";
}
