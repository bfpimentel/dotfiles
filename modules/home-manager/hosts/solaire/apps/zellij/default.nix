{ homeManagerConfig, config, ... }:

{
  programs.zellij.enable = true;

  home.file.".config/zellij".source = homeManagerConfig.linkHostApp config "zellij";
}
