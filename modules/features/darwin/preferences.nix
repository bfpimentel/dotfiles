{ ... }:

{
  config.bfmp.darwin.sharedModules = [
    (
      { lib, ... }:
      let
        screenshotsDirectory = "/Users/bruno/Documents/Screenshots";
      in
      {
        system.defaults = {
          NSGlobalDomain = {
            # Interface
            AppleInterfaceStyleSwitchesAutomatically = false;
            NSWindowShouldDragOnGesture = true;

            # Finder
            AppleShowAllExtensions = true;
            NSDocumentSaveNewDocumentsToCloud = false;

            # Menu bar
            _HIHideMenuBar = true;

            # Keyboard
            "com.apple.keyboard.fnState" = true;
            ApplePressAndHoldEnabled = false;
            NSAutomaticPeriodSubstitutionEnabled = false;
            InitialKeyRepeat = 12;
            KeyRepeat = 1;

            # Mission Control
            AppleSpacesSwitchOnActivate = false;
          };

          dock = {
            tilesize = 48;
            autohide = true;
            autohide-time-modifier = 0.0;
            autohide-delay = 0.0;
            show-recents = false;
            mineffect = "scale";

            # Mission Control
            mru-spaces = false;
            # nix-darwin uses 1 (Disabled), not the script's unsupported 0.
            wvous-tl-corner = 1;
            wvous-tr-corner = 1;
            wvous-bl-corner = 1;
            wvous-br-corner = 1;
          };

          finder = {
            AppleShowAllFiles = true;
            ShowPathbar = true;
            FXPreferredViewStyle = "Nlsv"; # List view
            _FXSortFoldersFirst = true;
            FXDefaultSearchScope = "SCcf"; # Search current folder
            FXRemoveOldTrashItems = true;
            FXEnableExtensionChangeWarning = false;
            ShowStatusBar = true;

            # Desktop
            CreateDesktop = false;
            ShowExternalHardDrivesOnDesktop = false;
            ShowRemovableMediaOnDesktop = false;
          };

          spaces.spans-displays = false;
          screencapture.location = screenshotsDirectory;

          # Matches the script; disabling quarantine weakens download protection.
          LaunchServices.LSQuarantine = false;

          # These keys have no dedicated nix-darwin options.
          CustomUserPreferences = {
            NSGlobalDomain = {
              NSSplitViewItemSidebarDefaultsToFloatingAppearance = false;
              NSSplitViewItemGlassMinimumCornerRadius = 1.0;
              NSConvolutionOverride1 = 1.0;
              # kCFPreferencesAnyApplication refers to the global domain.
              TSMLanguageIndicatorEnabled = false;
            };
            "com.apple.iphonesimulator".ScreenShotSaveLocation = screenshotsDirectory;
            "com.apple.appleseed.FeedbackAssistant".Autogather = false;
            "com.apple.CloudSubscriptionFeatures.optIn"."545129924" = false;
          };
        };

        # Activation runs as root; refresh only bruno's session.
        # Dock is already restarted by nix-darwin's userDefaults activation.
        system.activationScripts.postActivation.text = lib.mkAfter ''
          echo >&2 "refreshing macOS preferences..."
          /usr/bin/killall -qu bruno Finder SystemUIServer || true
          /usr/bin/sudo -H -u bruno \
            /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        '';
      }
    )
  ];
}
