{ config, ... }:

{
  home.file.".config/zsh" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
