{ pkgs,  ... }:

{
  environment.systemPackages = with pkgs; [
    aria2
    atuin
    awscli2
    bat
    cmake
    delta
    dust
    eternal-terminal
    eza
    fd
    fzf
    git
    go
    harper
    htop
    httpie
    hyperfine
    ijq
    jankyborders
    jq
    lazygit
    mise
    neofetch
    neovim
    pam-reattach
    parallel
    pkgs.home-manager
    rename
    ripgrep
    rsync
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
  programs.fish.enable = true;
  programs.zsh.enable = true;

  system.stateVersion = 5;

  nix.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

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
            <string>/tmp/user-pref-sync.log</string>
            <key>StandardErrorPath</key>
            <string>/tmp/user-pref-sync-err.log</string>
          </dict>
        </plist>
      '';
    };
  };

  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyleSwitchesAutomatically = true;
    AppleICUForce24HourTime = true;
    AppleMeasurementUnits = "Centimeters";
    AppleMetricUnits = 1;
    AppleTemperatureUnit = "Celsius";
    AppleShowAllExtensions = true;
    NSWindowShouldDragOnGesture = true;
    InitialKeyRepeat = 15;
    KeyRepeat = 1;
  };

  system.defaults.menuExtraClock = {
    Show24Hour = true;
    ShowDayOfWeek = false;
  };

  system.defaults.spaces.spans-displays = true;

  system.defaults.CustomUserPreferences = {
    "com.apple.dock" = {
      "expose-group-apps" = 1;
    };
    "com.apple.Safari" = {
      ShowOverlayStatusBar = 1;
      AlwaysRestoreSessionAtLaunch = 1;
      CloseTabsAutomatically = 1;
      EnableNarrowTabs = 1;
      NSUserKeyEquivalents = {
        "Copy Current Safari URL" = "@$c";
      };
    };
    "com.apple.Spotlight" = {
      "NSStatusItem Visible Item-0" = 0;
    };
    "com.apple.controlcenter" = {
      "NSStatusItem Visible NowPlaying" = 1;
      "NSStatusItem Visible Sound" = 1;
    };
  };
  system.defaults.dock = {
    expose-group-apps = true;
    wvous-br-corner = 1;
    wvous-bl-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
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
      "coreutils"
      "libyaml" # Dependency for ruby-build (mise)
      "ncurses"
      "xcode-build-server"
    ];
    masApps = {
      "Amphetamine" = 937984704;
      "Daisy Disk" = 411643860;
      "Patterns" = 429449079;
      "Things 3" = 904280696;
      "Telegram" = 747648890;
    };
    casks = [
      "1password"
      "1password-cli"
      "aerospace"
      "alfred"
      "apparency"
      "arq"
      "bettertouchtool"
      "dash"
      "fantastical"
      "font-fira-code-nerd-font"
      "font-sf-mono"
      "font-sf-pro"
      "ghostty"
      "homerow"
      "istat-menus"
      "jordanbaird-ice"
      "karabiner-elements"
      "neovide"
      "obsidian"
      "provisionql"
      "rocket"
      "sf-symbols"
      "slack"
      "suspicious-package"
      "thingsmacsandboxhelper"
    ];
  };

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
    watchIdAuth = true;
  };
}
