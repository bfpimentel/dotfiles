{ homeManagerConfig, config, ... }:

{
  home.file.".config/ghostty".source = homeManagerConfig.linkHostApp config "ghostty";
}
