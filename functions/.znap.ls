#!/bin/zsh
# ls plugins dir or repo
emulate -L zsh -o extendedglob -o NO_shortloops -o warncreateglobal

local -a files=()
local repo=$(.znap.path $1) || return
[[ -d $repo ]] && files+=( $repo )
[[ -f $cache ]] && files+=( $cache )
(( $#files > 0 )) && eval "ls -l $files"
