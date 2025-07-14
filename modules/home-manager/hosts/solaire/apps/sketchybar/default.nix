{ homeManagerConfig, config, ... }:

{
  home.file.".config/sketchybar".source = homeManagerConfig.linkHostApp config "sketchybar";
}
