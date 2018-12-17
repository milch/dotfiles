# Defined in /var/folders/zn/vphczcxn01g4lg4tnf8w0_k1yqft1l/T//fish.3gZf2K/fssh.fish @ line 2
function fssh --description 'Fuzzy-find ssh host via ag and ssh into it'
	rg --ignore-case '^host [^!*]' ~/.ssh/config* | cut -d ' ' -f 2 | fzf | read -l result; and ssh "$result"
end
