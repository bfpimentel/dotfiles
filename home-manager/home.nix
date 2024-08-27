{ lib, config, pkgs, username, email, fullname, ... }:

{
  imports = [
    "/etc/nixos/modules/home-manager/${username}"
  ];
  
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    enableNixpkgsReleaseCheck = false;
    stateVersion = "24.05";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      rnix = "sudo nixos-rebuild switch --impure";

      vim = "nvim";
      
      gst = "git status -sb";
      gf = "git fetch";
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
  };

  programs.home-manager.enable = true;
}
