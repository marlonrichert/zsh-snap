#!/bin/zsh
emulate zsh
zmodload zsh/param/private
local -P dir=${${(%):-%x}:P:h}
source $dir/scripts/init.zsh "$dir"
