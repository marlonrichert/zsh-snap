#!/bin/zsh

() {
  emulate -L zsh -o extendedglob -o NO_shortloops -o warncreateglobal

  typeset -gU FPATH fpath=( ${${(%):-%x}:A:h} $fpath )
  autoload -Uz znap
}
