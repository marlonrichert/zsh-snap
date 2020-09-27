#!/bin/zsh
() {
  emulate -L zsh -o extendedglob -o NO_shortloops -o warncreateglobal

  local basedir=${${(%):-%x}:A:h}
  local funcdir=$basedir/functions
  typeset -gU FPATH fpath=( $funcdir $basedir $fpath )
  autoload -Uz znap $funcdir/.znap.*

  if zstyle -T :znap: auto-compile; then
    zmodload zsh/parameter
    source .() {
      builtin $=funcstack[1] "$@"
      local -i ret=$?
      znap compile "$1:A" ${(M@)=funcstack:#*/*}
      return ret
    }
    .znap.compile.hook() {
      znap compile
      add-zle-hook-widget -d line-finish $=funcstack[1]
      zle -D $=funcstack[1]
    }
    zle -N .znap.compile.hook
    autoload -Uz add-zle-hook-widget
    add-zle-hook-widget line-finish .znap.compile.hook
    znap compile $funcstack[@]
  fi
}
