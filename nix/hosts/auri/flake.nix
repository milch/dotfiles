{ pkgs, ... }:

{
  imports = [ ../../shared/default.nix ];
  networking.computerName = "Auri";
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "manu";
  users.knownUsers = [ "manu" ];
  users.users.manu = {
    name = "manu";
    home = "/Users/manu";
    uid = 501;
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    exiftool
    ffmpeg
    gh
    imagemagick
    iperf
    just
    nmap
    pandoc
    qmk
  ];

  homebrew.masApps = {
    "1Blocker" = 1365531024;
    "1Password for Safari" = 1569813296;
    "Blackmagic Disk Speed Test" = 425264550;
    "CARROT Weather" = 993487541;
    "Consent-O-Matic" = 1606897889;
    "Flighty" = 1358823008;
    "Goodnotes" = 1444383602;
    "Noir" = 1592917505;
    "Parcel" = 639968404;
    "Refined GitHub" = 1519867270;
    "Save to Reader" = 1640236961;
    "SponsorBlock for Safari" = 1573461917;
    "StopTheMadness Pro" = 6471380298;
    "Surfingkeys" = 1609752330;
    "WireGuard" = 1451685025;
  };
  homebrew.casks = [
    "astropad-studio"
    "balenaetcher"
    "calibre"
    "calibrite-profiler"
    "discord"
    "expressvpn"
    "fastrawviewer"
    "google-chrome"
    "mactex"
    "moonlight"
    "nextcloud"
    "ollama"
    "orbstack"
    "orion"
    "plex"
    "steam"
    "topaz-photo-ai"
    "ultimaker-cura"
    "utm"
  ];

  system.defaults.dock = {
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
  };
}
