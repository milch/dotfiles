{
  description = "Dotfile configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        aria2
        atuin
        awscli2
        bat
        cmake
        delta
        dust
        eternal-terminal
        exiftool
        eza
        fd
        ffmpeg
        fswatch
        fzf
        gh
        git
        go
        htop
        httpie
        hyperfine
        ijq
        imagemagick
        iperf
        jankyborders
        jq
        just
        lazygit
        neofetch
        neovim
        nmap
        nodejs
        pam-reattach
        pandoc
        parallel
        pkgs.home-manager
        python3
        qmk
        rename
        ripgrep
        rsync
        ruby
        rustup
        shellcheck
        starship
        tmux
        tree
        tree-sitter
        unison
        wget
        zig
        zoxide
      ];
      environment.shells = [ pkgs.fish ];
      nix.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      networking.computerName = "Auri";

      users.knownUsers = [ "manu" ];
      users.users.manu = {
        name = "manu";
        home = "/Users/manu";
        uid = 501;
        shell = pkgs.fish;
      };


      security.pam.services.sudo_local = {
        enable = true;
        # Make touch ID sudo work with tmux
        reattach = true;
        # Enable sudo to unlock with touch ID
        touchIdAuth = true;
        # Enable sudo to unlock with Apple Watch
        watchIdAuth = true;
      };

      environment.userLaunchAgents = {
        "syncUserPreferences.plist" = {
          enable = true;
          text = ''
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
              <dict>
                <key>Label</key>
                <string>unison.user-pref-sync</string>
                <key>ProgramArguments</key>
                <array>
                  <string>${pkgs.unison}/bin/unison</string>
                  <string>-ui</string>
                  <string>text</string>
                  <string>sync-user-prefs</string>
                </array>
                <key>RunAtLoad</key>
                <true/>
                <key>StartInterval</key>
                <integer>300</integer>
                <key>StandardOutPath</key>
                <string>/Users/manu/Library/Logs/unison/user-pref-sync.log</string>
                <key>StandardErrorPath</key>
                <string>/Users/manu/Library/Logs/unison/user-pref-sync-err.log</string>
              </dict>
            </plist>
          '';
        };
      };

      system.keyboard.enableKeyMapping = true;

      system.defaults = {
        NSGlobalDomain = {
          # Switch between dark/light mode
          AppleInterfaceStyleSwitchesAutomatically = true;
          # Metric units everywhere
          AppleICUForce24HourTime = true;
          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = 1;
          AppleTemperatureUnit = "Celsius";
          # Shows all file extensions in Finder
          AppleShowAllExtensions = true;
          # Drag windows by clicking anywhere with cmd+ctrl
          NSWindowShouldDragOnGesture = true;

          # Maximum tracking speed
          "com.apple.trackpad.scaling" = 3.0;

          # Key repeat rate
          InitialKeyRepeat = 15;
          KeyRepeat = 1;
        };
        WindowManager.EnableStandardClickToShowDesktop = false;
        dock = {
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
          # Disables hot corners
          wvous-br-corner = 1;
          wvous-bl-corner = 1;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
        };
        menuExtraClock = {
          Show24Hour = true;
          ShowDayOfWeek = false;
        };
        spaces.spans-displays = true;
      };

      system.defaults.CustomUserPreferences = {
        "com.apple.dock" = {
          "expose-group-apps" = 1;
        };
        "com.apple.Safari" = {
          ShowOverlayStatusBar = 1;
          AlwaysRestoreSessionAtLaunch = 1;
          CloseTabsAutomatically = 1;
          EnableNarrowTabs = 1;
        };
        "com.apple.Spotlight" = {
          "NSStatusItem Visible Item-0" = 0;
        };
        "com.apple.controlcenter" = {
          "NSStatusItem Visible NowPlaying" = 1;
          "NSStatusItem Visible Sound" = 1;
        };
      };

      homebrew = {
        enable = true;
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
        onActivation.cleanup = "zap";
        taps = [
          "cormacrelf/tap"
          "nikitabobko/tap"
          "xcodesorg/made"
        ];
        brews = [
          "cormacrelf/tap/dark-notify"
          "xcodesorg/made/xcodes"
          "ncurses"
          "coreutils"
          "xcode-build-server"
        ];
        masApps = {
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
        casks = [
          "1password"
          "1password-cli"
          "aerospace"
          "alfred"
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
          "font-fira-code-nerd-font"
          "font-sf-mono"
          "font-sf-pro"
          "ghostty"
          "google-chrome"
          "homerow"
          "istat-menus"
          "jordanbaird-ice"
          "karabiner-elements"
          "mactex"
          "moonlight"
          "neovide"
          "nextcloud"
          "obsidian"
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
          "wezterm"
        ];
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Auri
    darwinConfigurations."Auri" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.manu = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Auri".pkgs;
  };
}
