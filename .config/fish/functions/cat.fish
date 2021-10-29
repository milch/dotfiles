# Defined in /var/folders/zn/vphczcxn01g4lg4tnf8w0_k1yqft1l/T//fish.PZTMUG/cat.fish @ line 2
function cat --description 'alias cat=bat'
	if test "$APPLE_INTERFACE_STYLE" = "dark"
		bat --theme=Dracula $argv;
	else
		bat --theme=GitHub $argv;
	end
end
