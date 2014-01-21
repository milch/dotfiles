# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# make vim default, use mvim provided binary
export EDITOR=vim
alias vim="mvim -v"

# use utf8
export LC_ALL=UTF8

plugins=(brew autojump rbenv battery git tmux)

source $ZSH/oh-my-zsh.sh

export PROMPT='%F{11}%n@%m %F{15}%~%(?..%{$fg[red]%}% ) › %f'
export RPROMPT='%F{blue}$(current_branch) %F{3}[%*]%f'

# vim-keybindings
bindkey -v

export GOPATH=/Users/Manu/go
export PATH=$PATH:~/.rbenv/shims:/usr/local/share/npm/bin:/opt/iOSOpenDev/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/usr/texbin:$GOPATH/bin

