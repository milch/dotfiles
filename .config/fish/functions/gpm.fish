function gpm
    set main_branch (git branch --color=never --list "main" "mainline" "master" | sed -E 's/\*? *//g')
    git pull --rebase origin $main_branch --autostash $argv
end
