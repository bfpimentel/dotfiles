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
      lua-language-server
      stylua

      bash-language-server

      yaml-language-server
      yamlfmt

      typescript-language-server
      tailwindcss-language-server
      vscode-langservers-extracted
      prettierd

      nil
      nixfmt-rfc-style
    ];
  };

  home.file.".config/nvim".source = homeManagerConfig.linkSharedApp config "neovim";
}
