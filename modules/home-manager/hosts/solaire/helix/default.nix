{ homeManagerConfig, config, ... }:

{
  home.file.".config/helix".source = homeManagerConfig.linkHostApp config "helix";
}
