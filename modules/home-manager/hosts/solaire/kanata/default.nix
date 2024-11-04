{ homeManagerConfig, config, ... }:

{
  home.file.".config/kanata".source = homeManagerConfig.linkHostApp config "kanata";
}
