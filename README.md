# ⚡️Znap!
**Znap** is the light-weight plugin manager for Zsh that's easy to grok.

* [Features](#features)
* [Installation](#installation)
* [Getting Started](#getting-started)
* [Author](#author)
* [License](#license)

## Features
🐥 *Low resource usage:*
Just ~18 kilobytes of [source code](#functions). Takes little disk space and little memory.

🔌 *Zero configuration:*
[`git clone` the repo](#installation), `source` the `.zsh` file, and you're good to go.

🏃 *Instant prompt:*
Reduce your startup time to only ~50ms [with just one command](#instant-prompt).

🛣 *Parallel downloads:*
Save time by downloading [multiple plugins at once](#clone-and-update-multiple-repos-in-parallel).

🏭 *Easy environment replication:*
Just copy [one file](#quickly-re-install-your-plugins) and run `znap clone` to instantly download
your favorite plugins into any Zsh profile.

⚙️ *Asynchronous compilation:*
Compiles your dotfiles, plugins and functions [in the background](#asynchronous-compilation).

## Installation
 1. `cd` to the dir where your (want to) keep your plugins. If you don't have one yet, you'll need
    to make one. I use the following:
    ```zsh
    % mkdir ~/.zsh
    % cd ~/.zsh
    ```
 1. `git clone` this repo. It will create a dir `zsh-snap` inside your plugins dir. This
    example uses `https` because you don't need a GitHub account for it, but if you do have one,
    you can use `ssh` instead:
    ```zsh
    % git clone https://github.com/marlonrichert/zsh-snap.git
    ```
    * _(optional)_ If you want to install Znap elsewhere, you'll need to tell it where to find your
      plugins dir, by adding this to your `.zshrc` file:
      ```zsh
      zstyle ':znap:*' plugins-dir ~/.zsh
      ```
 1. Add this line _at the top_ of your `.zshrc` file (or at least before your use Znap to manage
    any plugins):
    ```zsh
    source ~/.zsh/zsh-snap/znap.zsh
    ```
 1. **Restart your shell.**

## Getting Started
Here's a list of things that Znap can help you do more easily and more efficiently.

### Clone and Update Multiple Repos in Parallel
Use `znap clone` to download the plugins you want to use. If you pass it multiple remotes, it will
clone them all _in parallel,_ which can be much faster than cloning them one by one.

Here's an example of how to download multiple plugins in parallel, illustrating some of the
different URL syntaxes you can use:
```zsh
% znap clone marlonrichert/zsh-{autocomplete,edit,hist} \
    git@github.com:{ohmyzsh/ohmyzsh,sorin-ionescu/prezto}.git \
    https://github.com/zsh-users/zsh-{autosuggestions,syntax-highlighting}.git
```

If you pass `partial/URLs` to `znap clone`, they will get auto-prefixed with `https://github.com/`
and suffixed with `.git`. To change the prefix, add this line to your `~/.zshrc` file:
```zsh
zstyle ':znap:*' default-server 'git@github.com:'
```

To update all of your repos in parallel, just run `znap pull`.

### Quickly Re-install Your Plugins
Znap saves the URL of each remote you clone into
`${XDG_CONFIG_HOME:-$HOME/.config}/zsh/znap-repos`. Run `znap clone` without arguments to quickly
re-download all plugins listed in this file.

### Asynchronous Compilation
While you are using Zsh, Znap compiles your scripts and functions in the background, when the Zsh
Line Editor is idle. This way, your shell will start up even faster next time!

Should you not want this feature, you can disable it with `zstyle ':znap:*' auto-compile no`. You
can compile sources manually at any time with `znap compile`.

### Instant Prompt
Reduce your startup time just ~50 ms. All you need to do is add `znap prompt <theme name>` near
the top of your `.zshrc` file and you're good to go.

### Example `.zshrc` File
```zsh
# Source Znap at the start of your .zshrc file.
source ~/.zsh/zsh-snap/znap.zsh

# `znap prompt` makes your prompt appear **instantly.**
# You can start typing right away!
znap prompt agnoster

# For OhMyZsh or other repos containing multiple themes, use this syntax instead:
znap prompt ohmyzsh robbyrussell

# Now your prompt is visible and you can already start typing, even though your .zshrc file hasn't
# even finished loading yet!

# Then, while your prompt is visible and you're typing commands, the rest of your `.zshrc` file
# continues to be executed.

# Use Znap to load only those parts of OhMyZsh or Prezto that you really need.
znap source ohmyzsh lib/{git,theme-and-appearance} plugins/git
znap source prezto modules/{environment,history}

# Use Znap to load your plugins, like this:
znap source zsh-autocomplete
znap source zsh-edit

# Note that if a plugin requires additional config, there is nothing special you need to do. Just
# use normal Zsh syntax:

znap source zsh-hist
bindkey '^[q' push-line-or-edit

export ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-syntax-highlighting

# Use Znap to add repos to your `$path`. This useful for when a repo doesn't contain a plugin, but
# rather a standalone command.
typeset -gU PATH path=(
  $(znap path github-markdown-toc)
  $path[@]
  .
)

# Use Znap to cache the output of slow `eval` commands:

# This runs inside the LS_COLORS repo.
znap eval LS_COLORS 'gdircolors -b LS_COLORS'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# These don't have a repo, but the first arg will be used to name the cache file.
znap eval brew-shellenv 'brew shellenv'
znap eval pyenv-init 'pyenv init -'
znap eval pipenv-completion 'pipenv --completion'
```

Again, always **restart your shell** for changes to take effect.

## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)

## License
This project is licensed under the MIT License. See the
[LICENSE](LICENSE) file for details.
