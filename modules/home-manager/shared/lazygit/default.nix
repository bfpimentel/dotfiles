{ homeManagerConfig, config, ... }:

{
  home.file.".config/lazygit".source = homeManagerConfig.linkSharedApp config "lazygit";
}
