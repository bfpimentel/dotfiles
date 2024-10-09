{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [ lazy-nvim ];
  };

  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink (./. + "/config");
}
