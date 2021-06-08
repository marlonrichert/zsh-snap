##
# ⚠️ WARNING: Never manually `source` your .zshrc file! It can have unexpected
# side effects. Instead, to safely apply changes, use `znap restart`.
#


##
# Source Znap at the start of your .zshrc file.
#
source ~/git/zsh-snap/znap.zsh


##
# Use `znap prompt` to makes you prompt appear in ~40ms. You can start typing
# right away!
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


##
# Use ~[dynamically-named dirs] to add repos to your $path or $fpath.
# Znap will download them automatically.
#
fpath+=(
    ~[asdf-vm/asdf]/completions
    ~[asdf-community/asdf-direnv]/completions
    ~[zsh-users/zsh-completions]/src
)


##
# Use `znap compdef` to install generated completion functions:
#
znap compdef _kubectl 'kubectl completion  zsh'
znap compdef _rustup  'rustup  completions zsh'
znap compdef _cargo   'rustup  completions zsh cargo'
# These functions are regenerated automatically when any of the commands for
# which they generate completions is newer than the function cache.


##
# Use `znap source` to load your plugins.
#
znap source marlonrichert/zsh-autocomplete
znap source marlonrichert/zsh-edit

# ...or to load only those parts of Oh-My-Zsh or Prezto that you really need:
znap source sorin-ionescu/prezto modules/{environment,history}
znap source ohmyzsh/ohmyzsh \
    'lib/(*~(git|theme-and-appearance).zsh)' plugins/git

# `znap source` finds the right file automatically, but you can also specify
# one (or more) explicitly:
znap source asdf-vm/asdf asdf.sh

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
# Use `znap eval` to cache the output of slow commands.
#

# If the first arg is a repo, then the command will run inside it. Plus,
# whenever you update a repo with `znap pull`, its eval cache gets regenerated
# automatically.
znap eval trapd00r/LS_COLORS "$( whence -a dircolors gdircolors ) -b LS_COLORS"

# Here, the first arg does not refer to a repo, but is simply used as an
# identifier for the cache file.
znap eval pyenv-init ${${:-=pyenv}:A}' init -'

# The cache gets regenerated, too, when the eval command has changed. For
# example, here we include a variable. So, the cache gets invalidated whenever
# this variable has changed.
znap source marlonrichert/zcolors
znap eval   marlonrichert/zcolors "zcolors ${(q)LS_COLORS}"

# Here we include the full path to a command. Since that path includes a
# version number, the cache will be invalidated when that changes.
znap eval asdf-community/asdf-direnv "asdf exec $( asdf which direnv ) hook zsh"

# Another way to automatically invalidate a cache is to simply include a
# variable as a comment. Here, the caches below will get invalidated whenever
# the Python version changes.
znap eval pip-completion    "pip completion --zsh             # $PYENV_VERSION"
znap eval pipx-completion   "register-python-argcomplete pipx # $PYENV_VERSION"
znap eval pipenv-completion "pipenv --completion              # $PYENV_VERSION"

# Combine `znap eval` with `curl` or `wget` to download, cache and source
# individual files:
znap eval omz-git 'curl -fsSL \
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh'
