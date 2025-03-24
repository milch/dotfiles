# Personal home-manager configuration
{ config, pkgs, lib, ... }:

let
  # Import shared home-manager configuration
  sharedConfig = import ./shared/home.nix { inherit config pkgs lib; };
in
{
  # Import shared configuration
  imports = [ ./shared/home.nix ];

  # Personal Gemfile configuration
  home.file = {
    "Gemfile" = {
      source = ./Gemfile;
      onChange = sharedConfig.update-bundle;
    };
    "Gemfile.lock" = {
      source = ./Gemfile.lock;
      onChange = sharedConfig.update-bundle;
    };
  };

  # Personal Unison sync configuration
  home.file.".unison/sync-user-prefs.prf" = {
    text = ''
      # Roots of the synchronization
      ## unison currently not support ~/$HOME in preference file
      root = ${config.home.homeDirectory}
      root = ${config.home.homeDirectory}/dotfiles/unison
      prefer = newer
      atomic = Name .git*
      auto = true
      batch = true
      times = true
      terse = true

      # Keep a backup copy of every file in a central location
      backuplocation = central
      backupdir = ${config.home.homeDirectory}/.local/state/unison
      backup = Name *
      backupprefix = $VERSION.
      backupsuffix =

      ## macOS
      path = Library/Preferences/com.apple.symbolichotkeys.plist
      path = Library/Preferences/com.apple.print.custompresets.plist
      path = Library/Preferences/com.apple.print.custompapers.plist

      # Alfred
      path = Library/Preferences/com.runningwithcrayons.Alfred-Preferences.plist

      # Ice
      path = Library/Preferences/com.jordanbaird.Ice.plist

      # Rocket
      path = Library/Preferences/net.matthewpalmer.Rocket.plist

      # Karabiner (the UI writes to this - unison works better than HM for this)
      path = .config/karabiner/karabiner.json

      ignore = Name {.DS_Store}
    '';
  };
}
