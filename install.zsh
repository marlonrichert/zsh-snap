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
    local dir= err= repo=${${(%):-%x}:P:h}

    while [[ -z $dir ]]; do
      print 'Where do you (want to) keep your repos and/or plugins?'
      dir=${(D)repo:h}
      {
        vared -p '> %12F' dir
      } always {
        print -nP -- '%f'
      }

      [[ -z $dir ]] &&
          continue

      if ! err=$( ( : ${${(e)~dir}:a} ) 2>&1 ); then
        print -Pru2 -- "%F{9}${err#'(anon):'<->\: }%f"
        dir=
      elif dir=${${(e)~dir}:a} && [[ ! -e $dir ]]; then
        if read -q ${(%):-"?%fNo such dir %F{12}${(D)dir}%f. Create? [yn] "}; then
          zf_mkdir -pm 0700 - $dir ||
              dir=
        else
          dir=
        fi
        print
      elif [[ ! -d $dir ]]; then
        print -Pru2 - "%F{9}${(D)dir}is not a directory.%f"
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
