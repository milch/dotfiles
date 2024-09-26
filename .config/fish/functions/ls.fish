function ls --wraps='eza --long --icons=always --no-filesize --no-user --no-permissions --no-time' --description 'alias ls=eza --long --icons=always --no-filesize --no-user --no-permissions --no-time'
  eza --long --icons=always --no-filesize --no-user --no-permissions --no-time $argv
        
end
