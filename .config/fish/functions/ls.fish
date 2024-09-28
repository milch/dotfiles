function ls --wraps='eza --icons=always' --description 'alias ls=eza --icons=always'
    eza --icons=always -w 120 --group-directories-first --across $argv
end
