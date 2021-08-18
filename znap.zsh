#!/bin/zsh
emulate zsh
local dir=${${(%):-%x}:P:h}
source $dir/scripts/init.zsh "$dir"
