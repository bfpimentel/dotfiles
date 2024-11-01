{ homeManagerConfig, config, ... }:

{
  home.file.".config/karabiner".source = homeManagerConfig.linkHostApp config "karabiner";
}
