#!/bin/zsh
emulate zsh
typeset -gU PATH path FPATH fpath MANPATH manpath
() {
  emulate -L zsh
  typeset -gHa _znap_opts=( extendedglob globdots globstarshort rcquotes NO_nomatch nullglob )
  setopt $_znap_opts

  local -a basedir=( (#i)${${(%):-%x}:h} )  # case correction
  local funcdir=$basedir/functions
  fpath=( $funcdir $basedir $fpath )
  builtin autoload -Uz znap $funcdir/(|.).znap*~*.zwc

  local pluginsdir; zstyle -s :znap: plugins-dir pluginsdir ||
    pluginsdir=$basedir:h
  if ! [[ -d $pluginsdir ]]; then
    zmodload -F zsh/files b:zf_mkdir
    zf_mkdir -pm 0700 $pluginsdir
  fi
  hash -d znap=$pluginsdir

  ..znap.init "$@"
}
