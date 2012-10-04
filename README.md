Vim Configuration
=

Basics
-
* This Configuration uses pathogen to manage all of it's plugins. 
* Syntax highlighting is turned on by default
* The <leader> key was remapped to ',' 
* Since I prefer using Tabs instead of Spaces, the tabwidth is set to 4 and Tabs aren't expanded to Spaces by default
* Error sounds are completely turned off.
* Backups are turned off, as most people use git/hg anyway
* Arrow-Keys are turned off in normal mode, but are enabled in every other mode
* The encoding defaults to utf-8
* To make motion commands easier, relative line numbers are used
* Window movements are remapped to <CR>[jklh] instead of <CR>W[jklh] to save that one, important keystroke.


Plugins
-

###Coding###
*   clang_complete - 
    Excellent autocompletion for C, C++, Obj-C
*   cocoa - 
    Better support for the Obj-C language inside of vim (highlighting, ...)
*   snipmate - 
    Snippet support for many different filetypes
*   supertab - 
    Indent or autocomplete based on context
*   tagbar - 
    Provides a list of symbols to help navigate through code
*   autoclose - 
    Automatically closes brackets in a smart way
*   endwise - 
    Automatically put an 'end' at the end of a ruby block
*   fugitive - 
    Git support for vim
*   pasta - 
    Automatically indents pasted code

###Other###
*   Command-T - 
    Quickly find files using <leader>t 
*   golden-ratio -
    Resizes the active window according to the golden-ratio (disabled by default)
*   powerline -
    Fancy statusbar

Colorschemes
-

###Packages###

These packs include many colorschemes for different tastes. I included these mainly to try out new schemes whenever I feel like it.

* Color-Sampler-Pack
* janus-colors (This package includes the default, *jellybeans+*)

###Other###

* molokai
* pyte
* github
* grb256
* vividchalk
