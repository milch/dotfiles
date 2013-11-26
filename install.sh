#!/bin/bash

brew update && brew upgrade
brew install ag
brew install tmux

curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

ln -s ~/dotfiles/inputrc ~/.inputrc
ln -s ~/dotfiles/slate/slate ~/.slate
ln -s ~/dotfiles/tmux ~/.tmux
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/vim ~/.vim/
ln -s ~/dotfiles/vim/vimrc ~/.vimrc
ln -s ~/dotfiles/zshrc ~/.zshrc

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
