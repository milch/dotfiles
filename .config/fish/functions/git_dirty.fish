function git_dirty
set dirs (fd --type directory --maxdepth 1)
for dir in $dirs
if ! git -C $dir status --porcelain | wc -l | rg '0' >/dev/null
set dirty $dirty $dir
end
end
echo $dirty
end
