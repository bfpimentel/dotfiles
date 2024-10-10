{ homeManagerConfig, config, ... }:

{
  home.file.".config/aerospace".source = homeManagerConfig.linkHostApp config "aerospace";
}
