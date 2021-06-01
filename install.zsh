#!/bin/zsh
emulate zsh
() {
  {
    emulate -LR zsh -o extendedglob
    zmodload -F zsh/files b:zf_mkdir b:zf_mv

    print '\nConfiguring Znap...\n'

    unset zsh_directory_name_functions
    zsh_directory_name() { false }
    unfunction zsh_directory_name
    unhash -d znap 2>/dev/null

    local -a conf=()
    local dir repo=${${(%):-%x}:a:h}

    while [[ -z $dir ]]; do
      print 'Where do you (want to) keep your repos and/or plugins?'
      dir=${(D)repo:h}
      vared -p "> %F{12}" dir

      dir=${${(e)~dir}:a}
      if [[ ! -e $dir ]]; then
        if read -q ${(%):-"?%fNo such dir %F{12}${(D)dir}%f. Create? [yn] "}; then
          zf_mkdir -pm 0700 - $dir ||
              dir=
        else
          dir=
        fi
        print
      elif [[ ! -d $dir ]]; then
        print -u2 - "%f${(D)dir}is not a dir."
        dir=
      fi
    done

    if [[ -n $dir && $dir != $repo:h ]]; then
      if read -q ${(%):-"?%fMove Znap's own repo to %F{12}${(D)dir}%f, too? [yn] "} &&
          zf_mv "$repo" "$dir/"; then
        repo=$dir/${repo:t}
      else
        conf+=( "zstyle ':znap:*' repos-dir ${(D)dir}" )
      fi
      print
    fi

    local cmd="source ${(D)repo}/znap.zsh"
    local zshrc=${${:-${ZDOTDIR:-$HOME}/.zshrc}:a}

    print -P "\nUpdating %F{12}${(D)zshrc}%f..."

    [[ -f $zshrc ]] &&
        local contents="$( < $zshrc 2>/dev/null )"
    local -a lines=( "${(f@)contents}" )
    lines=( "${lines[@]:#[[:space:]]#source */znap.zsh*}" )
    lines=( "${lines[@]:#[[:space:]]#zstyle *:znap:* *-dir *}" )
    conf+=( "${(M)lines[@]:#[[:space:]]#zstyle *:znap:* *}" )
    lines=( "${lines[@]:#[[:space:]]#zstyle *:znap:* *}" )
    print -lr $conf[@] "$cmd" "$lines[@]" >| $zshrc

    print 'Installation complete.\n'
  } always {
    autoload -Uz $repo/functions/.znap.restart
    .znap.restart
  }
}
