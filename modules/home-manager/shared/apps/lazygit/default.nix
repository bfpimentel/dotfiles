{ homeManagerConfig, config, ... }:

{
  programs.lazygit.enable = true;

  home.file.".config/lazygit".source = homeManagerConfig.linkSharedApp config "lazygit";
}
