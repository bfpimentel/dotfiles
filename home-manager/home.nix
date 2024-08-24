{ inputs, outputs, lib, config, pkgs, ... } : 

{
  imports = [ ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "bruno";
    homeDirectory = "/home/bruno";
  };

  home.packages = with pkgs; [
  ];

  programs.neovim.enable = true;

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

  home.stateVersion = "24.05";
}
