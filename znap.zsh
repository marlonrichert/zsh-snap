#!/bin/zsh
() {
  emulate -L zsh
  typeset -gHa _znap_opts=( localoptions extendedglob globdots globstarshort nullglob rcquotes )
  setopt $_znap_opts

  local basedir=${${(%):-%x}:A:h}
  local funcdir=$basedir/functions
  typeset -gU FPATH fpath=( $funcdir $basedir $fpath )
  autoload -Uz znap $funcdir/.znap.*~*.zwc

  if zstyle -T :znap: auto-compile; then
    zmodload -Fa zsh/parameter p:funcstack
    source . () {
      builtin $funcstack[1] "$@"; local -i ret=$?
      .znap.compile "$1:A"
      return ret
    }
    .znap.compile
  fi

  .znap.function compdef '
    autoload -Uz compinit
    compinit
  '
  .znap.function _bash_complete compgen complete '
    autoload -Uz bashcompinit
    bashcompinit
  '

  :znap:compinit() {
    add-zsh-hook -d precmd :znap:compinit
    unfunction :znap:compinit
    [[ -v _comp_dumpfile ]] &&
      return
    autoload -Uz compinit
    compinit
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd :znap:compinit
}
