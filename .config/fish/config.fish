set -gx PATH /opt/homebrew/bin /usr/local/bin $PATH

if status --is-interactive; and not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Make nvim default editor
set -gx EDITOR nvim
set -gx GIT_EDITOR nvim
set -gx VISUAL nvim

## Set locale

set -gx LANG "en_US.UTF-8"
set -gx LC_COLLATE "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"

set -x MANPAGER 'nvim +Man!'

set -x GPG_TTY (tty)

function update_theme
    set type $argv[1]
    set -gx APPLE_INTERFACE_STYLE $type
    echo """
    [interactive]
    diffFilter = delta --$type --color-only
    [core]
    pager = delta --$type
    """ > ~/.gitconfig_delta
end

function set_color_scheme
    if test (defaults read -g AppleInterfaceStyle 2>/dev/null || echo '0') = 'Dark'
        yes | fish_config theme save 'Catppuccin Macchiato'
        set -gx BAT_THEME 'Catppuccin-macchiato'
        update_theme dark
    else
        yes | fish_config theme save 'Catppuccin Latte'
        set -gx BAT_THEME 'Catppuccin-latte'
        update_theme light
    end
end

status --is-interactive; and set_color_scheme

status --is-interactive; and source (pyenv init -|psub); and source (rbenv init -|psub); and source (nodenv init -|psub)

status --is-interactive; and test -e ~/.config/fish/local.fish; and source ~/.config/fish/local.fish

alias cp='rsync --info=progress2'

if status --is-interactive
    function update_color_scheme -d 'Set color scheme after every call' --on-event fish_postexec
        set_color_scheme
    end

    fish_vi_key_bindings
    starship init fish | source
end
