{ username, ... }:

{
  security.pam.enableSudoTouchIdAuth = true;

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        KeyRepeat = 2; # 120, 90, 60, 30, 12, 6, 2
        InitialKeyRepeat = 15; # 120, 94, 68, 35, 25, 15
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };
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
          "/Applications/Thunderbird Beta.app"
          "/Applications/Zen Browser.app"
          "/Applications/Nix Apps/kitty.app"
          "/Users/${username}/Applications/Android Studio.app"
        ];
        expose-animation-duration = 0.2;
        expose-group-apps = true;
        wvous-bl-corner = 1;
        wvous-br-corner = 4;
        wvous-tl-corner = 1;
        wvous-tr-corner = 12;
        mru-spaces = false;
      };
      finder = {
        _FXShowPosixPathInTitle = false;
        _FXSortFoldersFirst = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = false;
        ShowPathbar = true;
        ShowStatusBar = false;
      };
    };
  };
}
