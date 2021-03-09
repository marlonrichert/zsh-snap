#!/bin/zsh
emulate zsh
() {
  emulate -L zsh
  typeset -gHa _znap_opts=( extendedglob globdots globstarshort rcquotes NO_nomatch nullglob )
  setopt $_znap_opts

  local -a basedir=( (#i)${${(%):-%x}:h} )  # case correction
  local funcdir=$basedir/functions
  typeset -gU FPATH fpath=( $funcdir $basedir $fpath )
  builtin autoload -Uz znap $funcdir/*znap*~*.zwc

  local pluginsdir; zstyle -s :znap: plugins-dir pluginsdir ||
    pluginsdir=$basedir:h
  hash -d znap=$pluginsdir

  :znap:init "$@"
}
