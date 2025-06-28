{ homeManagerConfig, config, ... }:

{
  home.file.".config/hammerspoon".source = homeManagerConfig.linkHostApp config "hammerspoon";
  home.file.".config/ghostty".source = homeManagerConfig.linkHostApp config "ghostty";
}
