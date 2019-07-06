#!/usr/bin/env ruby

require 'fileutils'

def install_fisherman
  puts "Installing fisherman..."
  `curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish`
  `fish -c fisher`
end

def install_terminfo
  Dir.chdir(File.expand_path('~')) do
    puts "Installing terminfo files..."
    `tic -o ~/.terminfo tmux-256color.terminfo.txt`
    `tic -o ~/.terminfo tmux.terminfo.txt`
  end
end

def install_vim_plug
  # From https://github.com/junegunn/vim-plug
  puts "Installing Vim Plug..."
  `curl -fsLo ~/.config/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
end

def install_tmux_plugin_manager
  `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
end

def files_to_install
  ignore = %w[. .. .git .gitignore install.rb]
  glob = Dir.glob(File.join(__dir__, '**', '*'), File::FNM_DOTMATCH).map { |f| f.sub(/^#{__dir__}\//, '') }
  glob.reject { |file| ignore.any? { |i| file.match?(/^#{i}$/) || file.match?(/^#{i}\//) } || file.end_with?('/.') }
end

def gitignore_global
  puts "Configuring global gitignore"
  `git config --global core.excludesfile ~/.gitignore_global`
end

def install
  to_install = files_to_install

  # Grab only the directories and sort them by size so lower levels will be created before higher ones
  dirs = to_install.select { |f| File.directory?(f) }
                   .sort_by { |d| d.size }
  puts "Creating directories..."
  FileUtils.mkdir_p(dirs.map { |d| File.expand_path(d, '~') })
  
  files = to_install - dirs
  puts "Symlink files..."
  files.each do |file|
    in_home_dir = File.expand_path(file, '~')
    in_this_dir = File.expand_path(file, __dir__)
    FileUtils.ln_s(in_this_dir, in_home_dir, force: true)
  end

  install_fisherman
  install_tmux_plugin_manager
  install_vim_plug
  install_terminfo
  gitignore_global
end

install
