#!/bin/zsh
emulate -L zsh
zmodload -Fa zsh/files b:zf_ln b:zf_mkdir b:zf_rm
autoload -Uz add-zsh-hook
local -a match=() mbegin=() mend=() # These are otherwise leaked by zstyle.

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

export  XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache} \
        XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config} \
        XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share} \
        XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
typeset -gU PATH path FPATH fpath MANPATH manpath

private basedir=${${(%):-%x}:P:h:h}
if [[ -z $basedir ]]; then
  print -u2 "znap: Could not find Znap's repo. Aborting."
  print -u2 "znap: file name = ${(%):-%x}"
  print -u2 "znap: absolute path = ${${(%):-%x}:P}"
  print -u2 "znap: parent dir = ${${(%):-%x}:P:h}"
  return $(( sysexits[(i)NOINPUT] + 63 ))
fi
. $basedir/scripts/opts.zsh
setopt $_znap_opts

private sitefuncdir=$XDG_DATA_HOME/zsh/site-functions
fpath=( $basedir/completions $sitefuncdir $fpath[@] )
builtin autoload -Uz $basedir/functions/{znap,(|.).znap.*~*.zwc}

local gitdir=
..znap.repos-dir
if [[ -z $gitdir || ! -d $gitdir ]]; then
  print -u2 "znap: Could not find repos dir. Aborting."
  return $(( sysexits[(i)NOINPUT] + 63 ))
fi

zf_mkdir -pm 0700 $sitefuncdir $gitdir \
    $XDG_CACHE_HOME/zsh{,-snap} $XDG_CONFIG_HOME/zsh $XDG_DATA_HOME

zstyle -T :znap: auto-compile &&
    add-zsh-hook preexec ..znap.auto-compile
add-zsh-hook zsh_directory_name ..znap.dirname

typeset -gH _comp_dumpfile=${_comp_dumpfile:-$XDG_CACHE_HOME/zsh/compdump}
[[ -f $_comp_dumpfile && ${${:-${ZDOTDIR:-$HOME}/.zshrc}:P} -nt $_comp_dumpfile ]] &&
    zf_rm -f $_comp_dumpfile
zstyle -s :completion: cache-path _ ||
    zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/compcache
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
