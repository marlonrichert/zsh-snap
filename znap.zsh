#!/bin/zsh
() {
  emulate -L zsh
  typeset -gHa _znap_opts=( localoptions extendedglob globdots globstarshort nullglob rcquotes )
  setopt $_znap_opts

  local basedir=${${(%):-%x}:A:h}
  local funcdir=$basedir/functions
  typeset -gU FPATH fpath=( $funcdir $basedir $fpath )
  autoload -Uz znap $funcdir/.znap.*~*.zwc

  export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
  if [[ ! -d $XDG_CACHE_HOME ]]; then
    zmodload -F zsh/files b:zf_mkdir
    zf_mkdir -p $XDG_CACHE_HOME
  fi

  zstyle -s :completion: cache-path cache_path ||
    zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zcompcache"

  typeset -gH _comp_dumpfile=${_comp_dumpfile:-$XDG_CACHE_HOME/zcompdump}
  if [[ -f $_comp_dumpfile && ${${:-${ZDOTDIR:-$HOME}/.zshrc}:A} -nt $_comp_dumpfile ]]; then
    zmodload -F zsh/files b:zf_rm
    zf_rm -f $_comp_dumpfile
  fi

  if zstyle -T :znap: auto-compile; then
    zmodload -Fa zsh/parameter p:funcstack
    source . () {
      builtin $funcstack[1] "$@"; local -i ret=$?
      .znap.compile "$1:A" ${(M@)funcstack[@]:#*/*}
      return ret
    }

    local -a exclude=()
    zstyle -a :znap: auto-compile-ignore exclude
    local -a include=(
      ${(M@)funcstack[@]:#*/*}
      $_comp_dumpfile
      $^fpath/*~*.zwc(-^/)
      ${ZDOTDIR:-$HOME}/.z(log(in|out)|profile|sh(env|rc))(-^/)
    )
    .znap.compile ${include:#(${(~j:|:)~exclude})}
  fi

  .znap.function compdef '
    autoload -Uz compinit
    compinit -C -d $_comp_dumpfile
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

    if [[ ! -v _comp_dumpfile ]]; then
      autoload -Uz compinit
      compinit -C -d $_comp_dumpfile
    fi

    compinit() { : }
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd :znap:compinit
}
