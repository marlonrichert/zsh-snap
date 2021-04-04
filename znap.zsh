#!/bin/zsh
emulate zsh
typeset -gU PATH path FPATH fpath MANPATH manpath
() {
  emulate -L zsh

  local basedir=${${(%):-%x}:A:h}

  if [[ -z $basedir ]]; then
    print -u2 "znap: Base dir is null. Aborting."
    print -u2 "znap: file name = ${(%):-%x}"
    print -u2 "znap: absolute path = ${${(%):-%x}:A}"
    print -u2 "znap: parent dir = ${${(%):-%x}:A:h}"
    return 65
  fi

  . $basedir/.znap.opts.zsh
  setopt $_znap_opts

  fpath=( $basedir $fpath )
  builtin autoload -Uz $basedir/functions/{znap,(|.).znap.*~*.zwc}

  local gitdir
  zstyle -s :znap: repos-dir gitdir ||
    zstyle -s :znap: plugins-dir gitdir ||
      gitdir=$basedir:h:A

  if [[ -z $gitdir ]]; then
    print -u2 "znap: Repos dir is null. Aborting."
    return 65
  fi

  if ! [[ -d $gitdir ]]; then
    zmodload -F zsh/files b:zf_mkdir
    zf_mkdir -pm 0700 $gitdir
  fi
  hash -d znap=$gitdir

  ..znap.init "$@"
} "$@"
