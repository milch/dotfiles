set -gx PATH /opt/homebrew/opt/ncurses/bin /Applications/WezTerm.app/Contents/MacOS /opt/homebrew/bin /usr/local/bin $HOME/.cargo/bin $HOME/.local/bin $PATH
set -gx XDG_CONFIG_HOME "$HOME/.config"

if status --is-interactive; and not functions -q fisher
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

function update_theme
    set type $argv[1]
    set -gx APPLE_INTERFACE_STYLE $type
    set -gx DELTA_FEATURES "+$type-style"
end

function set_color_scheme
    if test "$apple_interface_style" = dark
        yes | fish_config theme save 'Catppuccin Macchiato'
        set -gx BAT_THEME Catppuccin-macchiato
    else
        yes | fish_config theme save 'Catppuccin Latte'
        set -gx BAT_THEME Catppuccin-latte
    end
    update_theme "$apple_interface_style"
end

function dark_notify
    set current_dir (dirname (status --current-filename))
    $current_dir/dark_notify.sh &
end

status --is-interactive; and set_color_scheme

status --is-interactive; and source (pyenv init -|psub); and source (rbenv init -|psub); and source (nodenv init -|psub)

test -e ~/.config/fish/local.fish; and source ~/.config/fish/local.fish

alias cp='rsync --info=progress2'
alias lg='TERM=screen-256color lazygit'

if status --is-interactive
    function update_color_scheme -d 'Set color scheme after every call' --on-variable apple_interface_style
        set_color_scheme
    end

    dark_notify

    fish_vi_key_bindings
    starship init fish | source
    zoxide init fish | source
end
