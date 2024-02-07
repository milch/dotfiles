# Defined in /var/folders/zn/vphczcxn01g4lg4tnf8w0_k1yqft1l/T//fish.3gZf2K/fssh.fish @ line 2
function fssh --description 'Fuzzy-find ssh host via ag and ssh into it'
    if set -q argv[1]
        rg --ignore-case '^host [^!*]' $argv[1] | cut -d ' ' -f 2 | sort | uniq | fzf | read -l result; and ssh "$result"
    else
        rg --ignore-case '^host [^!*]' ~/.ssh/config* | cut -d ' ' -f 2 | sort | uniq | fzf | read -l result; and ssh "$result"
    end
end
