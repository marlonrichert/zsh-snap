#!/bin/zsh
emulate zsh
zmodload zsh/param/private

local -P dir=${${(%):-%x}:P:h}
autoload -Uz $dir/scripts/init.zsh
{
	init.zsh "$dir"
} always {
  unfunction init.zsh
}
