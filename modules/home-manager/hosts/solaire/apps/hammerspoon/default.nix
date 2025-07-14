{ homeManagerConfig, config, ... }:

{
  home.file.".config/hammerspoon".source = homeManagerConfig.linkHostApp config "hammerspoon";
}
