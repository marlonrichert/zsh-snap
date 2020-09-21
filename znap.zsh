#!/bin/zsh
() {
  emulate -L zsh -o extendedglob -o NO_shortloops -o warncreateglobal

  local basedir=${${(%):-%x}:A:h}
  local funcdir=$basedir/functions
  typeset -gU FPATH fpath=( $funcdir $basedir $fpath )
  autoload -Uz znap $funcdir/.znap.*

  if zstyle -t :znap: auto-compile; then
    source() {
      znap compile "$1:A" $funcstack[@]
      builtin source "$@"
    }
    .() {
      znap compile "$1:A" $funcstack[@]
      builtin . "$@"
    }
    :znap:compile() {
      add-zle-hook-widget -d line-init :znap:compile
      znap compile
    }
    autoload -Uz add-zle-hook-widget
    add-zle-hook-widget line-init :znap:compile
    znap compile $funcstack[@]
  fi
}
