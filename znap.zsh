#!/bin/zsh
emulate zsh
typeset -gU PATH path FPATH fpath MANPATH manpath
path=( ~/.local/bin $path[@] )
() {
  emulate -L zsh

  [[ ${(t)sysexits} != *readonly ]] &&
      readonly -ga sysexits=(
          USAGE   # 64
          DATAERR
          NOINPUT
          NOUSER
          NOHOST
          UNAVAILABLE
          SOFTWARE
          OSERR
          OSFILE
          CANTCREAT
          IOERR
          TEMPFAIL
          PROTOCOL
          NOPERM
          CONFIG  # 78
      )

  local basedir=${${(%):-%x}:a:h}

  if [[ -z $basedir ]]; then
    print -u2 "znap: Could not find Znap's repo. Aborting."
    print -u2 "znap: file name = ${(%):-%x}"
    print -u2 "znap: absolute path = ${${(%):-%x}:a}"
    print -u2 "znap: parent dir = ${${(%):-%x}:a:h}"
    return $(( sysexits[(i)NOINPUT] + 63 ))
  fi

  . $basedir/.znap.opts.zsh
  setopt $_znap_opts

  fpath=( $basedir $fpath )
  builtin autoload -Uz $basedir/functions/{znap,(|.).znap.*~*.zwc}

  local gitdir
  zstyle -s :znap: repos-dir gitdir ||
      zstyle -s :znap: plugins-dir gitdir ||
          gitdir=$basedir:a:h

  if [[ -z $gitdir ]]; then
    print -u2 "znap: Could not find repos dir. Aborting."
    return $(( sysexits[(i)NOINPUT] + 63 ))
  fi

  [[ -d $gitdir ]] ||
      zf_mkdir -pm 0700 $gitdir
  hash -d znap=$gitdir

  ..znap.init "$@"
} "$@"
