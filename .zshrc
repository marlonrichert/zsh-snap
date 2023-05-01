##
# ⚠️ WARNING: Don't manually `source` your .zshrc file! This can have unexpected
# side effects.
# Instead, to apply changes, open a new terminal or restart your shell.
#


##
# Source Znap at the start of your .zshrc file.
#
source ~/git/zsh-snap/znap.zsh


##
# Does your shell feels slow to start? `znap prompt` reduces the time between
# opening your terminal and seeing your prompt to just 15 - 40 ms!
#
znap prompt agnoster/agnoster-zsh-theme

# `znap prompt` also supports Oh-My-Zsh themes. Just make sure you load the
# required libs first:
znap source ohmyzsh/ohmyzsh lib/{git,theme-and-appearance}
znap prompt ohmyzsh/ohmyzsh robbyrussell

# Using your own custom prompt? After initializing the prompt, just call
# `znap prompt` without arguments to get it to show:
PS1=$'%(?,%F{g},%F{r})%#%f '
znap prompt

# The same goes for any other kind of custom prompt:
znap eval starship 'starship init zsh --print-full-init'
znap prompt

# NOTE that `znap prompt` does not work with Powerlevel10k.
# With that theme, you should use its "instant prompt" feature instead.


##
# Load your plugins with `znap source`.
#
znap source marlonrichert/zsh-autocomplete
znap source marlonrichert/zsh-edit

# You can also choose to load one or more files specifically:
znap source sorin-ionescu/prezto modules/{environment,history}
znap source ohmyzsh/ohmyzsh \
    'lib/(*~(git|theme-and-appearance).zsh)' plugins/git


# No special syntax is needed to configure plugins. Just use normal Zsh
# statements:

znap source marlonrichert/zsh-hist
bindkey '^[q' push-line-or-edit
bindkey -r '^Q' '^[Q'

ZSH_AUTOSUGGEST_STRATEGY=( history )
znap source zsh-users/zsh-autosuggestions

ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-users/zsh-syntax-highlighting


##
# Cache the output of slow commands with `znap eval`.
#

# If the first arg is a repo, then the command will run inside it. Plus,
# whenever you update a repo with `znap pull`, its eval cache gets regenerated
# automatically.
znap eval trapd00r/LS_COLORS "$( whence -a dircolors gdircolors ) -b LS_COLORS"

# The cache gets regenerated, too, when the eval command has changed. For
# example, here we include a variable. So, the cache gets invalidated whenever
# this variable has changed.
znap source marlonrichert/zcolors
znap eval   marlonrichert/zcolors "zcolors ${(q)LS_COLORS}"

# Combine `znap eval` with `curl` or `wget` to download, cache and source
# individual files:
znap eval omz-git 'curl -fsSL \
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh'


##
# Defer initilization code with lazily loaded functions created by
# `znap function`.
#

# For each of the examples below, the `eval` statement on the right is not
# executed until you try to execute the associated command or try to use
# completion on it.

znap function _pyenv pyenv              'eval "$( pyenv init - --no-rehash )"'
compctl -K    _pyenv pyenv

znap function _pip_completion pip       'eval "$( pip completion --zsh )"'
compctl -K    _pip_completion pip

znap function _python_argcomplete pipx  'eval "$( register-python-argcomplete pipx  )"'
complete -o nospace -o default -o bashdefault \
           -F _python_argcomplete pipx

znap function _pipenv pipenv            'eval "$( pipenv --completion )"'
compdef       _pipenv pipenv
