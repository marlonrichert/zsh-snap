#!/bin/zsh
() {
  emulate -L zsh
  typeset -gHa _znap_opts=( localoptions extendedglob globdots globstarshort nullglob rcquotes )
  setopt $_znap_opts

  local basedir=${${(%):-%x}:A:h}
  local funcdir=$basedir/functions
  typeset -gU FPATH fpath=( $funcdir $basedir $fpath )
  autoload -Uz znap $funcdir/*znap*~*.zwc

  local pluginsdir; zstyle -s :znap: plugins-dir pluginsdir ||
    pluginsdir=$basedir:h
  hash -d znap=$pluginsdir

  :znap:init "$@"
}
