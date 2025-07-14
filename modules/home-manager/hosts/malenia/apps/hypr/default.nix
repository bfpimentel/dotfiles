{ homeManagerConfig, config, ... }:

{
  home.file.".config/hypr".source = homeManagerConfig.linkHostApp config "hypr";
}
