#!/bin/zsh

print -nr -- "${$( eval "${${(A)=aliases[ls]:-ls}[1]} --color=always -d $1" )} "
