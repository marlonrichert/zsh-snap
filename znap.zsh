#!/bin/zsh
typeset -gU FPATH fpath=( ${${(%):-%x}:A:h} $fpath )
autoload -Uz znap
