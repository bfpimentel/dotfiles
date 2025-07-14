{ homeManagerConfig, config, ... }:

{
  programs.wofi.enable = true;

  home.file.".config/wofi".source = homeManagerConfig.linkHostApp config "wofi";
}
