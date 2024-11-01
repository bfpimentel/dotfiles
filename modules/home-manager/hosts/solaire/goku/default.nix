{ homeManagerConfig, config, ... }:

{
  home.file.".config/goku".source = homeManagerConfig.linkHostApp config "goku";
}
