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

set -x MANPAGER "nvim -c 'set ft=man' -"

set -x GPG_TTY (tty)
set -g fish_user_paths "/usr/local/opt/llvm/bin" $fish_user_paths

function set_color_scheme
    if test (defaults read -g AppleInterfaceStyle 2>/dev/null || echo '0') = 'Dark'
        source $HOME/.config/fish/conf.d/dracula.fish
        set -g theme_color_scheme 'dracula'
        set -gx APPLE_INTERFACE_STYLE 'dark'
    else
        base16-papercolor-light
        set -g theme_color_scheme 'nord'
        set -gx APPLE_INTERFACE_STYLE 'light'
    end
end

status --is-interactive; and set_color_scheme
set -g theme_date_format "+%H:%M:%S"

status --is-interactive; and source (pyenv init -|psub); and source (rbenv init -|psub)

status --is-interactive; and test -e ~/.config/fish/local.fish; and source ~/.config/fish/local.fish


alias cp='rsync --info=progress2'


if status --is-interactive
    function update_color_scheme -d 'Set color scheme after every call' --on-event fish_postexec
        set_color_scheme
    end

    fish_vi_key_bindings
end
