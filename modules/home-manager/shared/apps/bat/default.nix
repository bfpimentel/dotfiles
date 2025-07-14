{ homeManagerConfig, config, ... }:

{
  home.file.".config/bat".source = homeManagerConfig.linkSharedApp config "bat";
}
