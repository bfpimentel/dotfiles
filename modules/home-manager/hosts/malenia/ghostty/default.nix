{ homeManagerConfig, config, ... }:

{
  programs.ghostty.enable = true;

  home.file.".config/ghostty".source = homeManagerConfig.linkHostApp config "ghostty";
}
