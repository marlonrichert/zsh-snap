# ⚡️Znap!
**Znap** is the light-weight Git repo manager & Zsh plugin manager that's easy to grok. While
tailored to Zsh plugins specifically, Znap can help you manage any number of Git repos, without them
needing to be plugins.

* [Features](#features)
* [Requirements](#requirements)
* [Installation](#installation)
* [Example `.zshrc` file](#example-zshrc-file)
* [Author](#author)
* [License](#license)

## Features
* 🐥 [Low resource usage](#low-resource-usage)
* 🔌 [Zero configuration](#zero-configuration)
* 🏃 [Instant prompt](#instant-prompt)
* 👨‍👩‍👧‍👦 [Multi repo management](#multi-repo-management)
* 🛣 [Parallel processing](#parallel-processing)
* 🏭 [Easy re-install](#easy-re-install)
* ⏭ [Automatic `compinit` and `bashcompinit`](#automatic-compinit-and-bashcompinit)
* ♻️ [Automatic completion cache invalidation](#automatic-completion-cache-invalidation)
* 🥫 [Command caching](#command-caching)
* ⚙️ [Asynchronous compilation](#asynchronous-compilation)

### Low resource usage
Only ~18 kilobytes of [source code](#functions). Takes little disk space and little memory.

### Zero configuration
`git clone` the repo [into the right place](#installation), `source` the `.zsh` file, and you're
good to go.

### Instant prompt
Add `znap prompt <theme name>` to your [`.zshrc` file](#example-zshrc) to reduce your startup
time to ~40ms (depending on your prompt theme).

### Multi repo management
Do `znap status` to run `git fetch` and see an abbreviated `git status` for all your repos at
once. Do `znap pull` to run `git pull` in all your repos. Use `znap ignore <repo> <pattern> ...`
to add entries to your repo's local exclude list.

Additionally, each of your repo dirs can now be referred to with `~[<repo>]`. So, instead of having
to type the full path to each repo, you can now do, for example, `ls ~[<repo>]/<subdir>...` or
`cd ~[<repo>]/<subdir>...`. And, of course, completions are available for these.

### Parallel processing
When you do `znap pull`, updates for all of your repos are downloaded in parallel. Use
`znap multi <command> ...` to run any number of tasks of any kind in parallel.

### Easy re-install
Znap saves the URL of each remote you clone into
`${XDG_CONFIG_HOME:-$HOME/.config}/zsh/znap-repos`. Should you ever "accidentally the whole thing",
just do `znap clone` without arguments to quickly re-clone all repos in parallel.

### Automatic `compinit` and `bashcompinit`
You no longer need to put `compinit` or `bashcompinit` in your `.zshrc` file. Znap will run
these for you as needed.

### Automatic completion cache invalidation
Znap automatically deletes and regenerates your comp dump file whenever you install or update a
plugin or change your `.zshrc` file.

### Command caching
Commands like `eval "$(brew shellenv)"`, `eval "$(pyenv init -)"` and
`eval "$(pipenv --completion)"` can be very slow to evaluate. If instead of
`eval "$( <command> )"`, you use `znap eval <name> <command>`, then the output of `<command>` will
get cached, which can speed things up considerably. Plus, if `<name>` is a repo, then `<command>`
will conveniently be evaluated inside it.

There are three cases that will cause `znap eval` to regenerate a cache:
* If `<name>` is a repo and the repo's Git index is newer than the cache.
* If the last argument to `znap eval` has changed. Thus, if `<command>` includes a variable, then
  its cached output will be regenerated whenever the variable changes. See the end of the
  [example `.zshrc` file below]((#example-zshrc-file)) for a practical use of this.
* If the cache is missing. Thus, you can use `znap rm <name>.zsh` to force `znap eval` to
  regenerate the `<name>` cache.

### Asynchronous compilation
While you are using Zsh, Znap compiles your scripts and functions in the background, when the Zsh
Line Editor is idle. This way, your shell will start up even faster next time!

Should you not want this feature, you can disable it with `zstyle ':znap:*' auto-compile no`. Or if
you want to exclude specific files only, you can do so by passing them as absolute-path patterns to
the `auto-compile-ignore` setting. For example:
`zstyle ':znap:*' auto-compile-ignore "${ZDOTDIR:-$HOME}/.z*" '**/.editorconfig' '**.md'`.

In any case, you can compile sources manually at any time with `znap compile`.

## Requirements
Recommended:
* Tested to work with **Zsh 5.7** or newer.

Minimum:
* Should theoretically work with Zsh 5.3, but I'm unable to test that. Definitely won't work with
  anything older.

## Installation
  1.  `cd` to the dir where your (want to) keep your Git repos. If you don't have one yet, you'll
      need to make one:
      ```zsh
      % mkdir -pm 0700 ~/git
      % cd ~/git
      ```
  1.  In there, `git clone` this repo:
      ```zsh
      % git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git
      ```
      * _(optional)_ By default, Znap clones all plugins into its parent directory (`~/git`, if you
        followed the first step). If you want to install them elsewhere, you can configure the
        plugins directory by adding this to your `.zshrc` file (_before_ the following step):
        ```zsh
        zstyle ':znap:*' plugins-dir ~/.local/share/znap
        ```
  1.  Add this line _at the start_ of your `.zshrc` file (or at least before you make any calls to
      `znap`):
      ```zsh
      source ~/git/zsh-snap/znap.zsh
      ```
  1.  **Restart your shell.**


## Example `.zshrc` file
```zsh
# Source Znap at the start of your .zshrc file.
source ~/git/zsh-snap/znap.zsh


# `znap prompt` makes your prompt appear in ~40ms. You can start typing right away!
znap prompt agnoster/agnoster-zsh-theme


# Now your prompt is visible and you can type, even though your .zshrc file hasn't finished loading
# yet! In the background, the rest of your `.zshrc` file continues to be executed.


# Use `znap source` to load only those parts of Oh-My-Zsh or Prezto that you really need:
znap source ohmyzsh/ohmyzsh plugins/git
znap source sorin-ionescu/prezto modules/{environment,history}

# `znap prompt` also supports Oh-My-Zsh themes. Just make sure you load the required libs first:
znap source ohmyzsh/ohmyzsh lib/{git,theme-and-appearance}
znap prompt ohmyzsh/ohmyzsh robbyrussell


# Use `znap source` to load your plugins:
znap source marlonrichert/zsh-autocomplete
znap source marlonrichert/zsh-edit

# `znap source` finds the right file to source automatically, but you can also specify one
# explicitly:
znap source asdf-vm/asdf asdf.sh

# Note that if a plugin requires additional config, there is nothing special you need to do. Just
# use normal Zsh syntax:

znap source marlonrichert/zsh-hist
bindkey '^[q' push-line-or-edit

ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-users/zsh-syntax-highlighting


# Use `znap eval` to cache the output of slow commands:

# If the first arg is a repo, then the command will run inside it. Plus, whenever you update a
# repo with `znap pull`, its eval cache gets regenerated automatically.
znap eval trapd00r/LS_COLORS 'gdircolors -b LS_COLORS'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# The cache gets regenerated, too, when the eval command has changed. So, for example, since we
# include the full path to `direnv` in the command string, the cache will be regenerated whenever
# the version of `direnv` changes.
znap eval asdf-community/asdf-direnv "asdf exec $(asdf which direnv) hook zsh"

# These don't belong to any repo, but the first arg will be used to name the cache file.
znap eval brew-shellenv 'brew shellenv'
znap eval pyenv-init ${${:-=pyenv}:A}' init -'
znap eval pip-completion 'pip completion --zsh'
znap eval pipx-completion 'register-python-argcomplete pipx'
znap eval pipenv-completion 'pipenv --completion'


# Use `znap compdef` to add generated completion functions:
znap compdef _kubectl 'kubectl completion zsh'
znap compdef _rustup  'rustup completions zsh'
znap compdef _cargo   'rustup completions zsh cargo'


# All repos managed by Znap are automatically available as dynamically-named dirs. This makes it
# easier to add commands to your `$path`...
path=(
  ~[ekalinin/github-markdown-toc]
  $path
  .
)

# ...or functions to your `$fpath`.
fpath=(
  ~[asdf-community/asdf-direnv]/completions
  $fpath
)

# Likewise, you can also do `cd ~[github-markdown-toc]` or `ls ~[asdf]/completions` to access a
# repo or its contents from any location. In addition, your plugins dir itself can be accessed with
#`cd ~znap` or `ls ~znap`. Try it on the command line!
```

As always, make sure you **restart your shell** for changes to take effect.


## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)


## License
This project is licensed under the MIT License. See the
[LICENSE](LICENSE) file for details.
