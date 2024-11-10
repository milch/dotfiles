function up
    set git_dir (git rev-parse --show-toplevel 2> /dev/null)
    if [ -z $git_dir ]
        cd ..
    else
        cd $git_dir
    end
end
