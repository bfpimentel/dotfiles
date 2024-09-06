{ config, ... }:

{
  home.file.".config/helix" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
