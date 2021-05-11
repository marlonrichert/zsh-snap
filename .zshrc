#
# ⚠️ WARNING: Never manually `source` your .zshrc file! It can have unexpected
# side effects. Instead, to safely apply changes, use `znap restart`.
#

# Source Znap at the start of your .zshrc file.
source ~/git/zsh-snap/znap.zsh


# `znap prompt` makes your prompt appear in ~40ms. You can start typing right
# away!
znap prompt agnoster/agnoster-zsh-theme

# `znap prompt` also supports Oh-My-Zsh themes. Just make sure you load the
# required libs first:
znap source ohmyzsh/ohmyzsh lib/{git,theme-and-appearance}
znap prompt ohmyzsh/ohmyzsh robbyrussell

# Using your own custom prompt? Just call `znap prompt` without arguments:
PS1=$'%(?,%F{g},%F{r})%#%f '
znap prompt


# Now your prompt is visible and you can type, even though your .zshrc file
# hasn't finished loading yet! In the background, the rest of your `.zshrc`
# file continues to be executed.

# ℹ️ NOTE: For the best experience, the theme you pass to `znap prompt` should
# implement Zsh's `promptinit` API. For more info, see
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Writing-Themes


# Use `znap source` to load only those parts of Oh-My-Zsh or Prezto that you
# really need:
znap source sorin-ionescu/prezto modules/{environment,history}
znap source ohmyzsh/ohmyzsh \
    'lib/(*~(git|theme-and-appearance).zsh)' plugins/git

# Use `znap source` to load your plugins:
znap source marlonrichert/zsh-autocomplete
znap source marlonrichert/zsh-edit

# `znap source` finds the right file automatically, but you can also specify
# one explicitly:
znap source asdf-vm/asdf asdf.sh


# No special syntax is needed for configuring plugins. Just use normal Zsh
# statements:

znap source marlonrichert/zsh-hist
bindkey '^[q' push-line-or-edit
bindkey -r '^Q' '^[Q'

ZSH_AUTOSUGGEST_STRATEGY=( history )
znap source zsh-users/zsh-autosuggestions

ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-users/zsh-syntax-highlighting


# Use `znap eval` to cache the output of slow commands:

# If the first arg is a repo, then the command will run inside it. Plus,
# whenever you update a repo with `znap pull`, its eval cache gets regenerated
# automatically.
znap eval trapd00r/LS_COLORS 'dircolors -b LS_COLORS'
znap source marlonrichert/zcolors
znap eval zcolors "zcolors ${(q)LS_COLORS}"

# The cache gets regenerated, too, when the eval command has changed. So, for
# example, since we include the full path to `direnv` in the command string,
# the cache will be regenerated whenever the version of `direnv` changes.
znap eval asdf-community/asdf-direnv "asdf exec $( asdf which direnv ) hook zsh"

# These don't belong to any repo, but the first arg will be used to name the
# cache file.
znap eval brew-shellenv 'brew shellenv'
znap eval pyenv-init ${${:-=pyenv}:A}' init -'  # Absolute path contains version number.
znap eval pip-completion 'pip completion --zsh'
znap eval pipx-completion 'register-python-argcomplete pipx'
znap eval pipenv-completion 'pipenv --completion'

# Combine `znap eval` with `curl` or `wget` to download, cache and source
# individual files:
znap eval omz-git \
    'curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh'


# Use `znap compdef` to add generated completion functions:
znap compdef _kubectl 'kubectl completion zsh'
znap compdef _rustup  'rustup completions zsh'
znap compdef _cargo   'rustup completions zsh cargo'
# These functions are automatically regenerated when any of the commands for
# which they complete is newer than the function.


# All repos managed by Znap are automatically available as dynamically-named
# dirs.

# This makes it easier to add commands to your `$path`...
path+=(
    ~[aureliojargas/clitest]
    ~[ekalinin/github-markdown-toc]
)

# ...or (completion) functions to your `$fpath`.
fpath+=(
    ~[asdf-community/asdf-direnv]/completions
    ~[zsh-users/zsh-completions]/src
)

# Likewise, you can also do
#   cd ~[github-markdown-toc]
# or
#   ls ~[asdf]/completions
# to access a repo or its contents from any location.

# In addition, your repos dir itself can be accessed with
#   cd ~znap
# or
#   ls ~znap

