{ config, lib, pkgs, hostname, ... }: 

{
  imports = [ ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  services.nix-daemon.enable = true;

  programs.zsh.enable = true;

  system.stateVersion = 4;

  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    dock = {
      # Dock
      appswitcher-all-displays = true;
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.15;
      orientation = "bottom";
      tilesize = 48;
      launchanim = false;
      minimize-to-application = true;
      show-process-indicators = true;
      show-recents = false;
      showhidden = true;
      static-only = false;
      dashboard-in-overlay = false;
      persistent-apps = [
        "/Applications/Psst.app"
        "/Applications/Thunderbird.app"
        "/Applications/Arc.app"
        "/Applications/Nix Apps/kitty.app"
        "/Users/bruno/Applications/Android Studio.app"
      ];
      # Mission Control
      expose-animation-duration = 0.2;
      expose-group-by-app = true;
      wvous-bl-corner = 1;
      wvous-br-corner = 4;
      wvous-tl-corner = 1;
      wvous-tr-corner = 12;
      mru-spaces = false;
    };
    finder = {
      _FXShowPosixPathInTitle = false;
      # _FXSortFoldersFirst = true;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = true;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      QuitMenuItem = false;
      ShowPathbar = true;
      ShowStatusBar = false;
    };
  };

  environment.systemPackages = with pkgs; [ 
    kitty
    eza
    bat
    rbenv
    kdoctor
    fzf
    fd
    gnupg
    neovim
    tmux
    nixd
    cargo
    localsend
    fastfetch
    lazygit
  ];

  homebrew = {
    enable = true;
    
    global = {
      autoUpdate = true;
    };

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };

    brews = [
      "lua"
      "ripgrep"
      "sketchybar"
      "borders"
    ];

    taps = [
      "nikitabobko/tap"
      "felixkratz/formulae"
    ];

    casks = [ 
      "xcodes" 
      "floorp" 
      "balenaetcher"  
      "vial"
      "thunderbird"
      "raspberry-pi-imager"
      "vlc"
      "linearmouse"
      "shottr"
      "hiddenbar"
      "notchnook"
      "raycast"
      "psst"
      "obsidian"
      "obs"
      "zoom"
      "altserver"
      "pearcleaner"
      "kap"
      "aerospace"
      "brave-browser@beta"
      "firefox@nightly"
      "font-space-mono-nerd-font"
    ];
  };
}

