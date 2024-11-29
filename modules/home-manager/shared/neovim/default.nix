{
  pkgs,
  homeManagerConfig,
  config,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.file.".config/nvim".source = homeManagerConfig.linkSharedApp config "neovim";
}
