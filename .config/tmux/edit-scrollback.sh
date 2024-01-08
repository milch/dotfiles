#!/bin/bash

file=$(mktemp).log
tmux capture-pane -p -S - -E - >"$file"
tmux new-window -n:mywindow "$EDITOR '+ normal G $' $file"
