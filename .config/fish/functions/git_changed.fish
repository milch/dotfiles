function git_changed
	set dirs (fd --type directory --maxdepth 1)
	for dir in $dirs
		if git -C $dir status | rg 'ahead' >/dev/null
			set changed $changed $dir
		end
	end
	echo $changed
end
