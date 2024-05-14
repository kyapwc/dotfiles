#!/bin/bash

# Close any open System Preferences panes, to prevent those panes from overriding the settings we will change below

osascript -e 'tell application "System Preferences" to quit'

# Ask for administrator password
sudo -v

# Keep-alive: update existing `sudo` timestamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Hide menu bar
defaults write NSGlobalDomain _HIHideMenuBar -int 1
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Faster repeat rate
defaults write NSGlobalDomain KeyRepeat -int 5
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Remap caps lock to CTRL
# Copied via nix: https://github.com/LnL7/nix-darwin/blob/230a197063de9287128e2c68a7a4b0cd7d0b50a7/modules/system/keyboard.nix
hidutil property --set '{"UserKeyMapping":{"HIDKeyboardModifierMappingSrc":30064771129,"HIDKeyboardModifierMappingDst":30064771296}}'

###############################################################################
# Energy saving                                                               #
###############################################################################

# Sleep the display after 15 minutes
sudo pmset -a displaysleep 15

# Disable machine sleep while charging
sudo pmset -c sleep 0

# Set standby delay to 24 hours (default is 1 hour)
sudo pmset -a standbydelay 86400

# Never go into computer sleep mode
sudo systemsetup -setcomputersleep Off > /dev/null

# Hibernation mode
# 0: Disable hibernation (speeds up entering sleep mode)
# 3: Copy RAM to disk so the system state can still be restored in case of a
#    power failure.
sudo pmset -a hibernatemode 0


###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allow quiting using CMD + Q
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: Disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# General configs for finder window
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
defaults write com.apple.finder "ShowPathbar" -bool "true"
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"

###############################################################################
# Dock, Dashboard & Hot corners                                               #
###############################################################################

# Set dock orientation, icon size, autohide and minimising effect
defaults write com.apple.dock "orientation" -string "left"
defaults write com.apple.dock "tilesize" -int "40"
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "mineffect" -string "scale"

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.2

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Kill all affected applications                                              #
###############################################################################
for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Messages" \
	"SystemUIServer"; do
	killall "${app}" &> /dev/null
done

echo "System preferences set."
