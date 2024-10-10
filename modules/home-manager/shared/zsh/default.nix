{
  system,
  config,
  homeManagerConfig,
  ...
}:

let
  systemSpecificRebuildCmd =
    if (system == "aarch64-darwin") then "darwin-rebuild" else "sudo nixos-rebuild";
in
{
  programs.zsh = {
    enable = true;
    envExtra = ''
      ZDOTDIR="${config.home.homeDirectory}/.config/zsh"
      alias rnix="${systemSpecificRebuildCmd} switch --flake /etc/nixos --impure"
    '';
  };

  home.file.".config/zsh".source = homeManagerConfig.linkSharedApp config "zsh";
}
