My dotfiles
===

Slate
---

I like to use my keyboard for everything when developing, as using the mouse feels way too slow. 
Slate offers features many window managers have on linux, namely using keyboard shortcuts to resize/focus/move windows. I use KeyRemap4Macbook and PCKeyboardHack to map my CapsLock to Shift+Ctrl+Alt+Cmd (dubbed by some on the internet as 'hyper'), so that I can use CapsLock as a modifier for keyboard shortcuts - all my Shortcuts for Slate are based on that. Here are the features I use most often:

- numpad: move & resize windows according to the position of the number on the numpad (5 = fullscreen, 7 = top left quarter, etc...)
- hyper + g: shows a grid to resize the current window similiar to Moom
- hyper + [hjkl]: push the current window to the border of the screen
- hyper + [→←↑↓]: same as numpad
- hyper + e: show window hints (shows a list of all open windows + shortcut to focus them)
- hyper + [12]: "Throw" the window to first or second screen

tmux
---

I only have very simple customizations for tmux. Instead of Ctrl+B as a prefix key I use Ctrl+A (like GNU screen) because it is easier to reach. I also have a few vim-style keybindings (prefix + [hjkl] to change split).

vim
---

Most important customizations:

- generally customized for development (what else?)
- the leader key is set to ","
- Solarized colorscheme all the way
- relative line numbers (great for moving around with [jk])
- tabs, no spaces
- no backups of files, that's what git and dropbox are for
- no arrow keys

I have too many vim plugins to count (I should probably uninstall some), but here are the most important:

- tagbar: leader + t - Shows symbols in a seperate split
- fugitive: git wrapper for vim
- ctrlp: leader + p - fuzzy filename search
- ack.vim: Use :Ack {query} to search for something inside of all the files in cwd
- powerline: awesome vim (it now has support for tmux - among others - as well) statusbar
- YouCompleteMe: semantic auto completion for C-based languages
- dispatch: Runs terminal/compiler-commands inside of a tmux split
- signature: m + , - place marks and visually display them

[[images/vim.png]]
*Plugins you can see here are: ack.vim, powerline, youcompleteme*

bash
---

The only customization I have for bash is the inputrc, which activates the history search - press ↓ or ↑ to search the history (so if you type "cd ~/dot" and then press ↑ it will show "cd ~/dotfiles/tmux" for example).

