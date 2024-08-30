{ config, ... }:

{
  home.file.".config/bat" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
