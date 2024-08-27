{ inputs, outputs, lib, config, pkgs, ... } : 

{
  imports = [ ];
  
  home = {
    username = "bruno";
    homeDirectory = "/home/bruno";
    enableNixpkgsReleaseCheck = false;
    stateVersion = "24.05";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.git = {
    enable = true;
    userName = "Bruno Pimentel";
    userEmail = "hello@bruno.so";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      rnix = "sudo nixos-rebuild switch --flake /home/bruno/.nix";

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

  programs.ssh = { 
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "bfpimentel";
        identityFile = "/home/bruno/.ssh/id_github";
      };
    };
  };

  programs.home-manager.enable = true;
}
