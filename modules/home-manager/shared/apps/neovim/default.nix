{
  pkgs,
  homeManagerConfig,
  config,
  inputs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    package = inputs.neovim-nightly.packages.${pkgs.system}.default;
    extraPackages = with pkgs; [
      lua-language-server
      stylua

      bash-language-server
      shfmt

      yaml-language-server
      yamlfmt

      typescript-language-server
      tailwindcss-language-server
      vscode-langservers-extracted
      prettier

      gopls

      # basedpyright
      ruff

      nil
      nixfmt-rfc-style

      copilot-language-server
    ];
  };

  home.file.".config/nvim".source = homeManagerConfig.linkSharedApp config "neovim";
}
