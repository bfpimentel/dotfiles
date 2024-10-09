{ config, ... }:

{
  home.file.".config/lazygit".source = config.lib.file.mkOutOfStoreSymlink (./. + "/config");
}
