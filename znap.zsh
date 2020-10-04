#!/bin/zsh
() {
  emulate -L zsh

  typeset -gHa _znap_opts=( localoptions extendedglob globstarshort rcquotes )
  setopt $_znap_opts

  local basedir=${${(%):-%x}:A:h}
  local funcdir=$basedir/functions
  typeset -gU FPATH fpath=( $funcdir $basedir $fpath )
  autoload -Uz znap $funcdir/.znap.*

  if zstyle -T :znap: auto-compile; then
    zmodload zsh/parameter
    source .() {
      .znap.clean "$1:A"
      builtin $=funcstack[1] "$@"
      local -i ret=$?
      .znap.compile "$1:A" ${(M@)=funcstack:#*/*}
      return ret
    }
    .znap.compile.hook() {
      .znap.compile
      local this=$=funcstack[1]
      add-zle-hook-widget -d line-finish $this
      zle -D $this
    }
    zle -N .znap.compile.hook
    autoload -Uz add-zle-hook-widget
    add-zle-hook-widget line-finish .znap.compile.hook
    .znap.compile ${(M@)=funcstack:#*/*}
  fi
}
