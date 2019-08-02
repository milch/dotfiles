if not functions -q fisher
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

set -gx TERM "xterm-256color"

set -x MANPAGER "nvim -c 'set ft=man' -"

set -x GPG_TTY (tty)
set -g fish_user_paths "/usr/local/opt/llvm/bin" $fish_user_paths

set -g theme_color_scheme 'dracula'
set -g theme_date_format "+%H:%M:%S"

status --is-interactive; and source (pyenv init -|psub)

test -e ~/.config/fish/local.fish; and source ~/.config/fish/local.fish

source ~/.config/fish/functions/dracula.fish

alias cp='rsync --info=progress2'
