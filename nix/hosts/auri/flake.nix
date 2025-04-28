# Configuration specific to the Auri host
{ pkgs, ... }:

{
  # Override computer name
  networking.computerName = "Auri";

  # Personal user configuration
  users.knownUsers = [ "manu" ];
  users.users.manu = {
    name = "manu";
    home = "/Users/manu";
    uid = 501;
    shell = pkgs.fish;
  };

  environment.systemPackages = [
    pkgs.exiftool
    pkgs.ffmpeg
    pkgs.gh
    pkgs.imagemagick
    pkgs.iperf
    pkgs.just
    pkgs.nmap
    pkgs.pandoc
    pkgs.qmk
  ];

  # Personal Homebrew configuration
  homebrew.taps = [
    "cormacrelf/tap"
    "nikitabobko/tap"
    "xcodesorg/made"
  ];
  homebrew.brews = [
    "cormacrelf/tap/dark-notify"
    "xcodesorg/made/xcodes"
    "xcode-build-server"
  ];
  homebrew.masApps = {
    "1Blocker" = 1365531024;
    "1Password for Safari" = 1569813296;
    "Amphetamine" = 937984704;
    "Blackmagic Disk Speed Test" = 425264550;
    "CARROT Weather" = 993487541;
    "Consent-O-Matic" = 1606897889;
    "Daisy Disk" = 411643860;
    "Flighty" = 1358823008;
    "Goodnotes" = 1444383602;
    "Patterns" = 429449079;
    "Save to Reader" = 1640236961;
    "SponsorBlock for Safari" = 1573461917;
    "StopTheMadness Pro" = 6471380298;
    "Things 3" = 904280696;
    "Surfingkeys" = 1609752330;
    "Telegram" = 747648890;
    "WireGuard" = 1451685025;
    "Parcel" = 639968404;
    "Noir" = 1592917505;
  };
  homebrew.casks = [
    "aerospace"
    "apparency"
    "astropad-studio"
    "arq"
    "bettertouchtool"
    "calibre"
    "calibrite-profiler"
    "dash"
    "discord"
    "expressvpn"
    "fantastical"
    "fastrawviewer"
    "google-chrome"
    "homerow"
    "istat-menus"
    "jordanbaird-ice"
    "mactex"
    "moonlight"
    "nextcloud"
    "ollama"
    "orbstack"
    "orion"
    "plex"
    "provisionql"
    "rocket"
    "sf-symbols"
    "slack"
    "steam"
    "suspicious-package"
    "thingsmacsandboxhelper"
    "topaz-photo-ai"
    "ultimaker-cura"
    "utm"
  ];

  # Personal dock configuration
  system.defaults.dock = {
    expose-group-apps = true;
    persistent-apps = [
      "/System/Applications/Photos.app"
      "/Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app"
      "/Applications/DaVinci Resolve/DaVinci Resolve.app"
      "/System/Applications/Music.app"
      "/Applications/Ghostty.app"
      "/Applications/Xcode-16.2.0.app"
      "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
      "/System/Applications/Messages.app"
      "/System/Applications/Mail.app"
      "/Applications/Slack.app"
      "/Applications/Telegram.app"
      "/Applications/Obsidian.app"
      "/Applications/Fantastical.app"
      "/Applications/Things3.app"
      "/Applications/CARROTweather.app"
      "/System/Applications/iPhone Mirroring.app"
    ];
    wvous-br-corner = 1;
    wvous-bl-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
  };
  };
}
