#!/bin/zsh
() {
  emulate -L zsh
  typeset -gHa _znap_opts=( localoptions extendedglob globstarshort rcquotes )
  setopt $_znap_opts

  local basedir=${${(%):-%x}:A:h}
  local funcdir=$basedir/functions
  typeset -gU FPATH fpath=( $funcdir $basedir $fpath )
  autoload -Uz znap $funcdir/.znap.*~*.zwc

  if zstyle -T :znap: auto-compile; then
    zmodload -F zsh/parameter p:funcstack
    source . () {
      builtin $funcstack[1] "$@"; local -i ret=$?
      .znap.compile "$1:A" ${(M@)funcstack[@]:#*/*}
      return ret
    }
    .znap.compile ${(M@)funcstack[@]:#*/*}
  fi
}
