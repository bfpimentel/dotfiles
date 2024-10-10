{ homeManagerConfig, config, ... }:

{
  home.file.".config/kitty".source = homeManagerConfig.linkHostApp config "kitty";
}
