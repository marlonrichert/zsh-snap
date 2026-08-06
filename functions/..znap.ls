#!/bin/zsh

print -nr -- "${$( eval "${${=aliases[ls]}[1]:-ls} --color=always -d $1" )} "
