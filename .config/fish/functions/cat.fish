# Defined in /var/folders/hl/swx6fly14j50lcyd5_rq2mlh0000gn/T//fish.t5mbbb/cat.fish @ line 2
function cat --description 'alias cat=bat'
	set theme GitHub
	if [ "$APPLE_INTERFACE_STYLE" = "dark" ]
		set theme Dracula
	end

	bat --theme=$theme $argv;
end
