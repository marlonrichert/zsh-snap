#!/bin/zsh
() {
  emulate -L zsh -o extendedglob -o NO_shortloops -o warncreateglobal

  local basedir=${${(%):-%x}:A:h}
  local funcdir=$basedir/functions
  typeset -gU FPATH fpath=( $funcdir $basedir $fpath )
  autoload -Uz znap $funcdir/.znap.*
}
