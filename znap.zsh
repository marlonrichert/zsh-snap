#!/bin/zsh
emulate zsh
typeset -gU PATH path FPATH fpath MANPATH manpath
() {
  emulate -L zsh
  typeset -gHa _znap_opts=(
    extendedglob globstarshort nullglob rcexpandparam NO_shortloops warncreateglobal
  )
  setopt $_znap_opts

  local basedir=${${(%):-%x}:A:h}

  if [[ -z $basedir ]]; then
    print -u2 "znap: Base dir is null. Aborting."
    print -u2 "znap: file name = ${(%):-%x}"
    print -u2 "znap: absolute path = ${${(%):-%x}:A}"
    print -u2 "znap: parent dir = ${${(%):-%x}:A:h}"
    return 65
  fi

  local funcdir=$basedir/functions
  fpath=( $funcdir $basedir $fpath )
  builtin autoload -Uz znap $funcdir/(|.).znap*~*.zwc

  local pluginsdir; zstyle -s :znap: plugins-dir pluginsdir ||
    pluginsdir=$basedir:h:A

  if [[ -z $pluginsdir ]]; then
    print -u2 "znap: Plugins dir is null. Aborting."
    return 65
  fi

  if ! [[ -d $pluginsdir ]]; then
    zmodload -F zsh/files b:zf_mkdir
    zf_mkdir -pm 0700 $pluginsdir
  fi
  hash -d znap=$pluginsdir

  ..znap.init "$@"
} "$@"
