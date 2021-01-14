# ⚡️Znap!
**Znap** is the light-weight plugin manager for Zsh that's easy to grok.

* [Features](#features)
* [Installation](#installation)
* [Example `.zshrc` file](#example-zshrc-file)
* [Author](#author)
* [License](#license)

## Features
* [Low resource usage](#low-resource-usage)
* [Zero configuration](#zero-configuration)
* [Instant prompt](#instant-prompt)
* [Command caching](#command-caching)
* [Parallel downloads](#parallel-downloads)
* [Automatic completion cache invalidation](#automatic-completion-cache-invalidation)
* [Asynchronous compilation](#asynchronous-compilation)
* [Easy re-install](#easy-re-install)

### Low resource usage
🐥 Only ~18 kilobytes of [source code](#functions). Takes little disk space and little memory.

### Zero configuration
🔌 [`git clone` the repo](#installation), `source` the `.zsh` file, and you're good to go.

### Instant prompt
🏃 Add `znap prompt <theme name>` to your [`.zshrc` file](#example-zshrc) to reduce your startup time
to ~40ms (depending on your prompt theme).

### Command caching
🥫 Commands like `eval "$(brew shellenv)"`, `eval "$(pyenv init -)"` and
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

### Parallel downloads
🛣 When you do `znap pull`, updates for all of your repos are downloaded in parallel.

### Automatic completion cache invalidation
♻️ Znap automatically deletes and regenerates your comp dump file whenever you install or update a
plugin or change your `.zshrc` file.

### Asynchronous compilation
⚙️ While you are using Zsh, Znap compiles your scripts and functions in the background, when the Zsh
Line Editor is idle. This way, your shell will start up even faster next time!

Should you not want this feature, you can disable it with `zstyle ':znap:*' auto-compile no`. Or if
you want to exclude specific files only, you can do so by passing them as absolute-path patterns to
the `auto-compile-ignore` setting. For example:
`zstyle ':znap:*' auto-compile-ignore "${ZDOTDIR:-$HOME}/.z*" '**/.editorconfig' '**.md'`.

In any case, you can compile sources manually at any time with `znap compile`.

### Easy re-install
🏭 Znap saves the URL of each remote you clone into
`${XDG_CONFIG_HOME:-$HOME/.config}/zsh/znap-repos`. Should you ever "accidentally the whole thing",
just do `znap clone` without arguments to quickly re-download all plugins in parallel.


## Installation
 1. `cd` to the dir where your (want to) keep your plugins. If you don't have one yet, you'll need
    to make one:
    ```zsh
    % mkdir ~/zsh
    % cd ~/zsh
    ```
 1. In there, `git clone` this repo:
    ```zsh
    % git clone https://github.com/marlonrichert/zsh-snap.git
    ```
    * _(optional)_ If you want to install Znap elsewhere, you'll need to tell it where to find your
      plugins dir, by adding this to your `.zshrc` file (_before_ your `source` Znap):
      ```zsh
      zstyle ':znap:*' plugins-dir ~/zsh
      ```
 1. Add this line _at the top_ of your `.zshrc` file (or at least before your use Znap to manage
    any plugins):
    ```zsh
    source ~/zsh/zsh-snap/znap.zsh
    ```
 1. **Restart your shell.**


## Example `.zshrc` file
```zsh

# Source Znap at the start of your .zshrc file.
source ~/zsh/zsh-snap/znap.zsh


# `znap prompt` makes your prompt appear in ~40ms. You can start typing right away!
znap prompt agnoster/agnoster-zsh-theme


# Now your prompt is visible and you can type, even though your .zshrc file hasn't finished loading
# yet! In the background, the rest of your `.zshrc` file continues to be executed.


# Use `znap source` to load only those parts of Oh-My-Zsh or Prezto that you really need:
znap source sorin-ionescu/prezto modules/{environment,history}

# `znap prompt` also supports Oh-My-Zsh themes. Just make sure you load the required libs first:
znap source ohmyzsh/ohmyzsh \
  lib/{git,theme-and-appearance} \
  plugins/git
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

export ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-users/zsh-syntax-highlighting


# Use `znap clone` to download repos that aren't plugins. All downloads in the same call will occur
# in parallel. Any repos you already have will be skipped silently.
znap clone \
  asdf-community/asdf-direnv \
  ekalinin/github-markdown-toc \
  trapd00r/LS_COLORS


# All repos managed by Znap are automatically available as dynamically-named dirs. This makes it
# easier to add commands to your `$path`...
export -U path=(
  ~[github-markdown-toc]
  $path
  .
)

# ...or functions to `$fpath`.
export -U fpath=(
  ~[asdf]/completions
  $fpath
)

# Likewise, you can also do `cd ~[github-markdown-toc]` or `ls ~[asdf]/completions` to access a
# repo and its contents from any location. In addition, your plugins dir itself can be accessed
# with `cd ~znap` or `ls ~znap`. Try it on the command line!


# Use `znap eval` to cache the output of slow commands:

# If the first arg is a repo, then the command will run inside it. Plus, whenever you update the
# repo with `znap pull`, the cache automatically gets regenerated.
znap eval LS_COLORS 'gdircolors -b LS_COLORS'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Here we include the full path to `direnv` in the command string, so that the cache will be
# regenerated whenever the version of `direnv` changes.
znap eval asdf-direnv "asdf exec $(asdf which direnv) hook zsh"

# These don't belong to any repo, but the first arg will be used to name the cache file.
znap eval brew-shellenv 'brew shellenv'
znap eval pyenv-init 'pyenv init -'
znap eval pipenv-completion 'pipenv --completion'

```

As always, make sure you **restart your shell** for changes to take effect.


## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)


## License
This project is licensed under the MIT License. See the
[LICENSE](LICENSE) file for details.
