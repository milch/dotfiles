#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'optparse'
require 'tmpdir'

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

def install_packer_nvim
  return unless File.exist?('~/.local/share/nvim/site/pack/packer/start/packer.nvim')

  puts 'Installing packer.nvim...'
  `git clone --depth 1 https://github.com/wbthomason/packer.nvim\
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim`
end

def files_to_install
  ignore = %w[. .. .git .gitignore install.rb iTerm]
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

def get_sf_mono # rubocop:disable Naming/AccessorMethodName
  # Get the font
  `curl https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg --output SF-Mono.dmg`
  `hdiutil attach SF-Mono.dmg`
  FileUtils.cp('/Volumes/SFMonoFonts/SF Mono Fonts.pkg', '.')
  `xar -xf 'SF Mono Fonts.pkg'`
  `tar -xzf SFMonoFonts.pkg/Payload`
end

def patch_sf_mono
  `wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontPatcher.zip`
  `unzip FontPatcher.zip`

  Dir['Library/Fonts/*.otf'].each do |font|
    `fontforge -script font-patcher --use-single-width-glyphs --complete --adjust-line-height --careful #{font}`
  end
end

def install_patched_fonts
  Dir['*Complete.otf'].each do |font|
    FileUtils.mv(font, File.expand_path('~/Library/Fonts/'))
  end
end

def install_patched_sf_mono
  return if File.exist?(File.expand_path('~/Library/Fonts/SFMono Regular Nerd Font Complete.otf'))

  Dir.mktmpdir do |tmp|
    Dir.chdir(tmp) do
      get_sf_mono
      patch_sf_mono
      install_patched_fonts
    end
  end
end

def symlink_files
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
end

def install_bat_theme
  puts 'Installing bat theme...'
  `git clone https://github.com/catppuccin/bat /tmp/catppuccin-bat`
  `mkdir -p "$(bat --config-dir)/themes"`
  `cp /tmp/catppuccin-bat/*.tmTheme "$(bat --config-dir)/themes"`
  `bat cache --build`
end

def run_install(options)
  symlink_files if options[:symlink]
  install_brew if options[:install_brew]
  brew_bundle if options[:brew_bundle]
  install_runtimes if options[:install_runtimes]
  install_packer_nvim if options[:nvim]
  if options[:tmux]
    install_terminfo
    install_tmux_plugin_manager
  end
  install_patched_sf_mono if options[:fonts]
  install_bat_theme if options[:bat_theme]
end

def parse_options(args)
  options = {}
  OptionParser.new do |parser|
    parser.on('--symlink', 'Symlink files into the $HOME folder')
    parser.on('--install_brew', 'Install homebrew')
    parser.on('--brew_bundle', 'Run brew bundle to install all OS level dependencies')
    parser.on('--install_runtimes', 'Installs Python & Ruby runtimes')
    parser.on('--nvim', 'Installs neovim related dependencies (e.g. package manager)')
    parser.on('--tmux', 'Installs tmux related dependencies (e.g. package manager)')
    parser.on('--fonts', 'Patches and installs fonts with Nerd Fonts patcher')
    parser.on('--bat_theme', 'Installs themes for bat')
  end.parse!(args, into: options)
  options
end

def install(args)
  options = parse_options(args)

  if options.empty?
    %i[symlink install_brew brew_bundle install_runtimes nvim tmux fonts bat_theme].each do |opt|
      options[opt] = true
    end
  end

  run_install(options)
end

install(ARGV)
