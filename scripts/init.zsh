#!/bin/zsh
() {
  emulate -L zsh
  zmodload -Fa zsh/files b:zf_ln b:zf_mkdir b:zf_rm
  autoload -Uz add-zsh-hook

  export XDG_DATA_HOME=${XDG_DATA_HOME:-~/.local/share}
  local basedir=$1 datadir=$XDG_DATA_HOME/zsh/site-functions
  local funcdir=$basedir/functions

  if [[ -z $basedir ]]; then
    print -u2 "znap: Could not find Znap's repo. Aborting."
    print -u2 "znap: file name = ${(%):-%x}"
    print -u2 "znap: absolute path = ${${(%):-%x}:P}"
    print -u2 "znap: parent dir = ${${(%):-%x}:P:h}"
    return $(( sysexits[(i)NOINPUT] + 63 ))
  fi

  . $basedir/scripts/opts.zsh
  setopt $_znap_opts

  typeset -gU PATH path FPATH fpath MANPATH manpath
  path=( ~/.local/bin $path[@] )
  fpath=( $fpath[@] $datadir )

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

  [[ -d $datadir ]] ||
      zf_mkdir -pm 0700 $datadir
  [[ -r $datadir/_znap ]] ||
      zf_ln -fns $funcdir/_znap $datadir/_znap
  builtin autoload -Uz $funcdir/{znap,(|.).znap.*~*.zwc}

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

  if zstyle -T :znap: auto-compile; then
    () {
      setopt localoptions NO_warncreateglobal
      zmodload -F zsh/parameter p:funcstack
      zmodload -F zsh/zselect b:zselect

      local fd
      exec {fd}< <(
        zselect -t 100
        print
      )
      zle -F "$fd" ..znap.auto-compile
    }
  fi

  add-zsh-hook zsh_directory_name ..znap.dirname

  export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
  [[ -d $XDG_CONFIG_HOME/zsh ]] ||
      zf_mkdir -pm 0700 $XDG_CONFIG_HOME/zsh

  export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
  [[ -d $XDG_CACHE_HOME/zsh ]] ||
      zf_mkdir -pm 0700 $XDG_CACHE_HOME/zsh
  [[ -d $XDG_CACHE_HOME/zsh-snap ]] ||
      zf_mkdir -pm 0700 $XDG_CACHE_HOME/zsh-snap

  typeset -gH _comp_dumpfile=${_comp_dumpfile:-$XDG_CACHE_HOME/zsh/compdump}
  [[ -f $_comp_dumpfile && ${${:-${ZDOTDIR:-$HOME}/.zshrc}:a} -nt $_comp_dumpfile ]] &&
      zf_rm -f $_comp_dumpfile

  zstyle -s :completion: cache-path _ ||
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/compcache"
  zstyle -s ':completion:*' completer _ ||
      zstyle ':completion:*' completer _expand _complete _ignored

  .znap.function bindkey 'zmodload zsh/complist'
  typeset -gHa _znap_compdef=()
  compdef() {
    _znap_compdef+=( "${(j: :)${(@q+)@}}" )
  }
  compinit() {:}
  add-zsh-hook precmd ..znap.compinit-hook
  [[ -v functions[_bash_complete] ]] ||
      .znap.function _bash_complete compgen complete '
        autoload -Uz bashcompinit
        bashcompinit
        bashcompinit() {:}
      '
} "$@"
