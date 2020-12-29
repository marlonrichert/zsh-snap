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
      .znap.compile "$1:A" ${(M@)funcstack[@]:#*/*}
      return ret
    }
    local -a exclude=(); zstyle -a :znap: auto-compile-ignore exclude
    local -a include=(
      ${(M@)funcstack[@]:#*/*}
      $^fpath/*~*.zwc(-^/)
      ${ZDOTDIR:-$HOME}/.z(log(in|out)|profile|sh(env|rc))(-^/)
    )
    .znap.compile ${include:#(${(~j:|:)~exclude})}
  fi

  .znap.function compdef '
    autoload -Uz compinit
    compinit
    compinit() { : }
  '
  .znap.function _bash_complete compgen complete '
    autoload -Uz bashcompinit
    bashcompinit
    bashcompinit() { : }
  '

  :znap:compinit() {
    add-zsh-hook -d precmd :znap:compinit
    unfunction :znap:compinit

    if [[ -v _comp_dumpfile ]]; then
      compinit() { : }
      return
    fi

    autoload -Uz compinit
    compinit
    compinit() { : }
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd :znap:compinit
}
