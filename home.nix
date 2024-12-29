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
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = [ ];

  home.preferXdgDirectories = true;

  home.file = {
    ".config/nvim/init.lua".source = .config/nvim/init.lua;
    ".config/nvim/lua".source = .config/nvim/lua;

    ".config/aerospace/aerospace.toml".source = .config/aerospace/aerospace.toml;

    ".config/lazygit".source = .config/lazygit;

    ".config/rubocop/config.yml".source = .config/rubocop/config.yml;

    ".config/starship.toml".source = .config/starship.toml;

    ".config/wezterm".source = .config/wezterm;

    ".config/tmux/catppuccin-latte.conf".source = .config/tmux/catppuccin-latte.conf;
    ".config/tmux/catppuccin-macchiato.conf".source = .config/tmux/catppuccin-macchiato.conf;
    ".config/tmux/tmux.conf".source = .config/tmux/tmux.conf;

    ".config/fish/dark_notify.sh".source = .config/fish/dark_notify.sh;
    ".config/fish/functions".source = .config/fish/functions;
    ".config/fish/themes/Catppuccin Latte.theme".source = "${catppuccin-fish}/themes/Catppuccin Latte.theme";
    ".config/fish/themes/Catppuccin Macchiato.theme".source = "${catppuccin-fish}/themes/Catppuccin Macchiato.theme";

    ".config/ghostty/config".source = .config/ghostty/config;

    ".markdownlintrc".source = ./.markdownlintrc;
    ".yamllint.yaml".source = ./.yamllint.yaml;

    "Gemfile" = {
      source = ./Gemfile;
      onChange = update-bundle;
    };
    "Gemfile.lock" = {
      source = ./Gemfile.lock;
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

      ignore = Name {.DS_Store}
      '';
    };
  };

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

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/opt/ncurses/bin"
    "/Applications/WezTerm.app/Contents/MacOS"
    "/usr/local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
      starship init fish | source
      zoxide init fish | source

      # Enable nix-shell to work in fish
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

      test -n "$GHOSTTY_RESOURCES_DIR"; and source "$GHOSTTY_RESOURCES_DIR"/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
    '';
  };

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
      pull = {
        rebase = true;
      };
      rebase = {
        autostash = true;
      };
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

  # Fallback if something doesn't work in fish
  programs.zsh.enable = true;
}
