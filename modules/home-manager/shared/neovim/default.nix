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
    package = inputs.neovim-nightly-overlay.packages."${pkgs.system}".default;
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
