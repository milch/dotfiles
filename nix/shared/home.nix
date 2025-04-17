# This file contains shared home-manager configuration that can be imported by both personal and work machines
{ config, pkgs, lib, ... }:

let
  catppuccin-fish = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "cc8e4d8fffbdaab07b3979131030b234596f18da";
    hash = "sha256-udiU2TOh0lYL7K7ylbt+BGlSDgCjMpy75vQ98C1kFcc=";
  };
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "d2bbee4f7e7d5bac63c054e4d8eca57954b31471";
    hash = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
  };
  update-bundle = ''
      export PATH="${lib.makeBinPath [ pkgs.ruby ]}:$PATH"
      bundle install --frozen
  '';
in
{
  home.stateVersion = "24.05";

  home.preferXdgDirectories = true;

  # Common dotfiles
  home.file = {
    ".config/nvim/init.lua".source = ../../.config/nvim/init.lua;
    ".config/nvim/lua/plugins".source = ../../.config/nvim/lua/plugins;
    ".config/nvim/lua/ui".source = ../../.config/nvim/lua/ui;
    ".config/nvim/lua/disable_defaults.lua".source = ../../.config/nvim/lua/disable_defaults.lua;
    ".config/nvim/lua/opt.lua".source = ../../.config/nvim/lua/opt.lua;
    ".config/nvim/lua/neovide.lua".source = ../../.config/nvim/lua/neovide.lua;
    ".config/nvim/lua/lazy_file.lua".source = ../../.config/nvim/lua/lazy_file.lua;
    ".config/nvim/lua/keybindings.lua".source = ../../.config/nvim/lua/keybindings.lua;


    ".config/aerospace/aerospace.toml".source = ../../.config/aerospace/aerospace.toml;

    ".config/lazygit".source = ../../.config/lazygit;

    ".config/rubocop/config.yml".source = ../../.config/rubocop/config.yml;

    ".config/starship.toml".source = ../../.config/starship.toml;

    ".config/wezterm".source = ../../.config/wezterm;

    ".config/tmux/catppuccin-latte.conf".source = ../../.config/tmux/catppuccin-latte.conf;
    ".config/tmux/catppuccin-macchiato.conf".source = ../../.config/tmux/catppuccin-macchiato.conf;
    ".config/tmux/tmux.conf".source = ../../.config/tmux/tmux.conf;

    ".config/fish/dark_notify.sh".source = ../../.config/fish/dark_notify.sh;
    ".config/fish/functions".source = ../../.config/fish/functions;
    ".config/fish/themes/Catppuccin Latte.theme".source = "${catppuccin-fish}/themes/Catppuccin Latte.theme";
    ".config/fish/themes/Catppuccin Macchiato.theme".source = "${catppuccin-fish}/themes/Catppuccin Macchiato.theme";

    ".config/ghostty/config".source = ../../.config/ghostty/config;

    ".markdownlintrc".source = ../../.markdownlintrc;
    ".yamllint.yaml".source = ../../.yamllint.yaml;

    ".config/mise/config.toml" = {
      text = ''
        [tools]
        node = 'lts'
        python = '3'
        ruby = '3'
      '';
    };

    "Gemfile" = {
      source = ../../Gemfile;
      onChange = update-bundle;
    };
    "Gemfile.lock" = {
      source = ../../Gemfile.lock;
      onChange = update-bundle;
    };

    ".unison/sync-user-prefs.prf" = {
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
  };

  # Common shell aliases
  home.shellAliases = {
    cp = "rsync --info=progress2";
    ls = "eza --icons=always -w 120 --group-directories-first --across";
    pcd = "fzf-cdhist-widget";
    lg = "TERM=screen-256color lazygit";
    cat = "bat";
    be = "bundler exec";
    bi = "bundler install";
    bu = "bundler update";
    ga = "git add";
    gb = "git branch";
    gc = "git commit";
    gca = "git commit --amend --no-edit";
    gcm = "git commit --message";
    gco = "git checkout";
    gpull = "git pull";
    gpush = "git push";
    gs = "git status";
  };

  # Common PATH additions
  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/opt/ncurses/bin"
    "/Applications/WezTerm.app/Contents/MacOS"
    "/usr/local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  # Common environment variables
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_COLLATE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    XDG_CONFIG_HOME = "$HOME/.config";
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
  };

  # Common activation scripts
  home.activation = {
    installTerminfo = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/.terminfo/74
      cp -f /opt/homebrew/Cellar/ncurses/6.5/share/terminfo/74/tmux-256color $HOME/.terminfo/74
    '';
    installTpm = lib.hm.dag.entryAfter ["writeBoundary"] ''
      export PATH="${lib.makeBinPath [ pkgs.git ]}:$PATH"
      test -d $HOME/.config/tmux/plugins/tpm || git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm
    '';
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Fish shell configuration
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      function update_theme
        set type $argv[1]
        set -gx APPLE_INTERFACE_STYLE $type
        set -gx DELTA_FEATURES "+$type-style"
      end

      function set_color_scheme
        if test "$apple_interface_style" = dark
          yes | fish_config theme save 'Catppuccin Macchiato'
          set -gx BAT_THEME "Catppuccin Macchiato"
        else
          yes | fish_config theme save 'Catppuccin Latte'
          set -gx BAT_THEME "Catppuccin Latte"
        end
        update_theme "$apple_interface_style"
      end

      function dark_notify
        $HOME/.config/fish/dark_notify.sh &
      end

      set_color_scheme

      test -e ~/.config/fish/local.fish; and source ~/.config/fish/local.fish

      function update_color_scheme -d 'Set color scheme after every call' --on-variable apple_interface_style
        set_color_scheme
      end

      dark_notify

      fish_vi_key_bindings
      ${pkgs.starship}/bin/starship init fish | source
      ${pkgs.zoxide}/bin/zoxide init fish | source

      # Enable nix-shell to work in fish
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

      # Set up atuin integration
      ${pkgs.atuin}/bin/atuin init --disable-up-arrow fish | source

      ${pkgs.mise}/bin/mise activate fish | source

      test -n "$GHOSTTY_RESOURCES_DIR"; and source "$GHOSTTY_RESOURCES_DIR"/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
    '';
  };

  # Bat configuration
  programs.bat = {
    enable = true;
    themes = {
      "Catppuccin Latte" = {
        src = catppuccin-bat;
        file = "themes/Catppuccin Latte.tmTheme";
      };
      "Catppuccin Macchiato" = {
        src = catppuccin-bat;
        file = "themes/Catppuccin Macchiato.tmTheme";
      };
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    lfs.enable = true;
    delta = {
      enable = true;
      options = {
        line-numbers = true;
        tabs = 2;
      };
    };
    attributes = [
      "*.m     diff=objc"
      "*.mm    diff=objc"
      "*.cs    diff=csharp"
      "*.css   diff=css"
      "*.html  diff=html"
      "*.xhtml diff=html"
      "*.exs   diff=elixir"
      "*.pl    diff=perl"
      "*.py    diff=python"
      "*.md    diff=markdown"
      "*.rake  diff=ruby"
      "*.rs    diff=rust"
      "*.el    diff=lisp"
      "*.plist diff=plist"
    ];
    ignores = [
      # Compiled source
      "*.com"
      "*.class"
      "*.dll"
      "*.exe"
      "*.o"
      "*.so"
      "*.dylib"

      # Logs and databases
      "*.log"
      "*.sqlite"

      # OS generated files
      ".DS_Store"
      ".DS_Store?"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "ehthumbs.db"
      "Thumbs.db"

      ".solargraph.yml"
    ];
    extraConfig = {
      pull.rebase = true;
      rebase.autostash = true;
      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };
      difftool.prompt = false;
      mergetool.prompt = false;
      "delta \"light-style\"".dark = false;
      "delta \"dark-style\"".dark = true;
      "diff \"plist\"" = {
        textconv = "plutil -p";
        binary = true;
      };
    };
  };

  # Readline configuration
  programs.readline = {
    enable = true;
    bindings = {
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
    variables = {
      "show-all-if-ambiguous" = true;
      "completion-ignore-case" = true;
    };
  };

  # Fallback shell
  programs.zsh.enable = true;
}
