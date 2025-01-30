{ homeManagerConfig, config, ... }:

{
  programs.waybar.enable = true;

  home.file.".config/waybar".source = homeManagerConfig.linkHostApp config "waybar";
}
