zmodload zsh/param/private
. scripts/opts.zsh
setopt ${_znap_opts:#warn*}
builtin autoload -Uz $PWD/functions/{znap,(|.).znap.*~*.zwc}
true
