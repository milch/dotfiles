#!/bin/bash

brew update && brew upgrade
brew install ag
brew install tmux

ln -s ~/dotfiles/inputrc ~/.inputrc
ln -s ~/dotfiles/slate/slate ~/.slate
ln -s ~/dotfiles/tmux ~/.tmux
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/vim ~/.vim/
ln -s ~/dotfiles/vim/vimrc ~/.vimrc
