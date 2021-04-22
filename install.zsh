#!/bin/zsh
emulate zsh
() {
  emulate -LR zsh -o extendedglob
  print '\nConfiguring Znap...\n'

  zmodload -F zsh/files b:zf_mkdir b:zf_mv

  unset zsh_directory_name_functions
  zsh_directory_name() { false }
  unfunction zsh_directory_name
  unhash -d znap 2>/dev/null

  local -a conf=()
  local dir repo=${${(%):-%x}:A:h}
  while [[ -z $dir ]]; do
    print 'Where do you (want to) keep your repos and/or plugins?'
    vared -p '> ' -r "[leave blank to use %F{12}${(D)repo:h}%f/]" dir
    [[ -z $dir ]] &&
      break
    dir=${${(e)~dir}:A}
    if [[ ! -e $dir ]]; then
      if read -q ${(%):-"?No such dir %F{12}${(D)dir}%f. Create? [yn] "}; then
        zf_mkdir -pm 0700 - $dir ||
          dir=
      else
        dir=
      fi
      print
    elif [[ ! -d $dir ]]; then
      print -u2 - "${(D)dir}is not a dir."
      dir=
    fi
  done
  if [[ -n $dir ]]; then
    if read -q ${(%):-"?Move Znap's own repo to %F{12}${(D)dir}%f, too? [yn] "} &&
        zf_mv "$repo" "$dir/"; then
      repo=$dir/${repo:t}
    else
      conf+=( "zstyle ':znap:*' repos-dir ${(D)dir}" )
    fi
    print
  fi
  local cmd="source ${(D)repo}/znap.zsh"
  local zshrc=${${:-${ZDOTDIR:-$HOME}/.zshrc}:A}
  print "\nUpdating ${(D)zshrc}..."
  [[ -f $zshrc ]] &&
    local contents="$( < $zshrc 2>/dev/null )"
  local -a lines=( "${(f@)contents}" )
  lines=( "${lines[@]:#[[:space:]]#source */znap.zsh*}" )
  lines=( "${lines[@]:#[[:space:]]#zstyle *:znap:* *-dir *}" )
  conf+=( "${(M)lines[@]:#[[:space:]]#zstyle *:znap:* *}" )
  lines=( "${lines[@]:#[[:space:]]#zstyle *:znap:* *}" )
  print -lr $conf[@] "$cmd" "$lines[@]" >| $zshrc

  print 'Installation complete.\n'

  autoload -Uz $repo/functions/.znap.restart
  .znap.restart
}
