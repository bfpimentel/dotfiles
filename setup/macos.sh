#!/bin/bash

if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle --upgrade

sudo -v

# Global
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write NSGlobalDomain _HIHideMenuBar -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSWindowShouldDragOnGesture -bool true

defaults write NSGlobalDomain com.apple.trackpad.scaling -int -1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Finder
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder CreateDesktop -bool false
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder NewWindowTarget PfHm
defaults write com.apple.finder FXPreferredViewStyle Nlsv
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXSortFoldersFirst -bool true

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

chflags nohidden ~/Library

# Misc
defaults write com.apple.screencapture location ~/Documents/Screenshots

# Dock
defaults write com.apple.Dock appswitcher-all-displays -bool true
defaults write com.apple.Dock autohide -bool true
defaults write com.apple.Dock autohide-delay -float 0.0
defaults write com.apple.Dock autohide-time-modifier -float 0.15
defaults write com.apple.Dock tilesize -int 48
defaults write com.apple.Dock launchanim -bool false
defaults write com.apple.Dock minimize-to-application -bool true
defaults write com.apple.Dock show-process-indicators -bool true
defaults write com.apple.Dock show-recents -bool false
defaults write com.apple.Dock showhidden -bool false
defaults write com.apple.Dock static-only -bool false
defaults write com.apple.Dock dashboard-in-overlay -bool false
defaults write com.apple.Dock expose-animation-duration -float 0.2
defaults write com.apple.Dock expose-group-apps -bool true
defaults write com.apple.Dock wvous-bl-corner -int 1
defaults write com.apple.Dock wvous-br-corner -int 1
defaults write com.apple.Dock wvous-tl-corner -int 1
defaults write com.apple.Dock wvous-tr-corner -int 1
defaults write com.apple.Dock mru-spaces -bool false

dockutil --add "/Applications/Helium.app"
dockutil --add "/Applications/kitty.app"

APPS=(
  Finder
  Dock
  SystemUIServer
)

for APP in "${APPS[@]}"; do
  killall "$APP" &>/dev/null
done
