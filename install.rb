#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'

RB_VERSION = '2.7.2'
PYTHON_VERSION = '3.9.1'

def install_terminfo
  Dir.chdir(File.expand_path('~')) do
    puts 'Installing terminfo files...'
    `tic -o ~/.terminfo tmux-256color.terminfo.txt`
    `tic -o ~/.terminfo tmux.terminfo.txt`
  end
end

def install_tmux_plugin_manager
  return if Dir.exist?(File.expand_path('~/.tmux/plugins/tpm'))

  puts 'Installing tpm...'

  `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
end

def install_vim_plug
  # From https://github.com/junegunn/vim-plug
  puts 'Installing Vim Plug...'
  `curl -fsLo ~/.config/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
end

def files_to_install
  ignore = %w[. .. .git .gitignore install.rb]
  glob = Dir.glob(File.join(__dir__, '**', '*'), File::FNM_DOTMATCH).map { |f| f.sub(%r{^#{__dir__}/}, '') }
  glob.reject { |file| ignore.any? { |i| file.match?(/^#{i}$/) || file.match?(%r{^#{i}/}) } || file.end_with?('/.') }
end

def install_brew
  puts 'Installing homebrew if it is missing...'
  `which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
end

def brew_bundle
  `brew bundle`
end

def install_runtimes
  puts 'Installing ruby and python runtimes...'
  `rbenv install #{RB_VERSION}`
  `rbenv global #{RB_VERSION}`
  `pyenv install #{PYTHON_VERSION}`
  `pyenv global #{PYTHON_VERSION}`

  puts 'Installing configured runtime dependencies...'

  `rbenv exec gem install bundle && cd ~ && rbenv exec bundle install`
  `cd ~ && pyenv exec pip install -r requirements.txt`
end

def install
  to_install = files_to_install

  # Grab only the directories and sort them by size so lower levels will be created before higher ones
  dirs = to_install.select { |f| File.directory?(f) }
                   .sort_by(&:size)
  puts 'Creating directories...'
  FileUtils.mkdir_p(dirs.map { |d| File.expand_path(d, '~') })

  files = to_install - dirs
  puts 'Symlink files...'
  files.each do |file|
    in_home_dir = File.expand_path(file, '~')
    in_this_dir = File.expand_path(file, __dir__)
    FileUtils.ln_s(in_this_dir, in_home_dir, force: true)
  end

  install_brew
  brew_bundle

  install_runtimes

  install_vim_plug
  install_terminfo
  install_tmux_plugin_manager
end

install
