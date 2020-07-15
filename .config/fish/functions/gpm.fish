# Defined in - @ line 1
function gpm --description 'alias gpm=git pull --rebase origin mainline --autostash'
	git pull --rebase origin mainline --autostash $argv;
end
