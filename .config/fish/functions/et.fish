# Defined in /var/folders/zn/vphczcxn01g4lg4tnf8w0_k1yqft1l/T//fish.7LTSRa/et.fish @ line 2
function et
    if string match -q "*dev*d*sk*" "$argv[-1]"
        /opt/homebrew/bin/et -c 'cd '(pwd | ruby -e "puts ARGF.readline.chomp.sub(%r(^$HOME), '~')")' && printf "\033c" && zsh' $argv
    else
        # Not dev desktop, just pass through
        /opt/homebrew/bin/et $argv
    end
end
