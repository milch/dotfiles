# Defined in /var/folders/hl/swx6fly14j50lcyd5_rq2mlh0000gn/T//fish.ilbfch/gpm.fish @ line 2
function gpm --description 'alias gpm=git pull --rebase origin mainline --autostash'
	set main_branch (git branch --color=never --list "main" "mainline" "master" | sed -E 's/\*? *//g')
	git pull --rebase origin $main_branch --autostash $argv;
end
