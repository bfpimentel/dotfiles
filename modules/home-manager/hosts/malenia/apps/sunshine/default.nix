{ homeManagerConfig, config, ... }:

{
  home.file.".config/sunshine".source = homeManagerConfig.linkHostApp config "sunshine";
}
