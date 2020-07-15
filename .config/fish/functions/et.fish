# Defined in /var/folders/zn/vphczcxn01g4lg4tnf8w0_k1yqft1l/T//fish.IcVuVp/et.fish @ line 2
function et
	/usr/local/bin/et -c 'cd '(pwd | ruby -e "puts ARGF.readline.chomp.sub(%r(^$HOME), '~')")' && printf "\033c" && zsh' $argv
end
