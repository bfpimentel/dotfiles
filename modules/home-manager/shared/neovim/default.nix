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
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    extraPackages = with pkgs; [
      nil
      lua-language-server
      bash-language-server
      yaml-language-server
      typescript-language-server
      tailwindcss-language-server
      nixfmt-rfc-style
      prettierd
    ];
  };

  home.file.".config/nvim".source = homeManagerConfig.linkSharedApp config "neovim";
}
