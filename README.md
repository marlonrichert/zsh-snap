# ⚡️Znap!
**Znap** is the light-weight Git repo manager & Zsh plugin manager that's easy to grok. While
tailored to Zsh plugins specifically, Znap can help you manage Git repos of any kind.

> Enjoy using this software? [Become a sponsor!](https://github.com/sponsors/marlonrichert)

## Installation
Just copy-paste the following into your command line and press <kbd>Enter</kbd>:
```zsh
git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git
source zsh-snap/install.zsh
```

### Requirements
* Recommended: **Zsh 5.7.1 or newer**
* Minimum: Zsh 5.4.2

## Features & Usage
Please see [the included `.zshrc` file](.zshrc) for examples of how to use Znap in your dotfiles.

### Install executables
Download repos simultaneously & symlink their executables to `~/.local/bin`:
```zsh
znap install aureliojargas/clitest bigH/git-fuzzy ekalinin/github-markdown-toc
```
To remove repos & symlinks, use `znap uninstall`:
```zsh
znap uninstall clitest git-fuzzy github-markdown-toc
```

### Automatic `compinit` and `bashcompinit`
You no longer need to call
[`complist`](http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fcomplist-Module),
[`compinit` or
`bashcompinit`](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Initialization) in
your `.zshrc` file. Znap will run these for you as needed.

### Named dirs
Znap makes your repos dir and all of its subdirs available as [named
directories](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Filename-Expansion):
```zsh
% cd ~znap                  # `cd` to your repos dir
% cd ~[github-markdown-toc] # `cd` to a repo
% ls ~[asdf]/completions    # `ls` a subdir in a repo
```

### Automatic cache invalidation
Znap automatically regenerates your [comp dump
file](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Use-of-compinit) whenever you
install or update a repo or change your `.zshrc` file.

Znap also automatically regenerates its internal cache for each command when…
* …a cache file is older than the Git index of its associated repo.
* …the last argument of the `znap eval` statements that produced it has changed. So, if the last
  argument to `znap eval` contains a variable, then its cached output will be regenerated whenever
  the variable changes. See the [example `.zshrc` file](.zshrc) for a practical use of this.
* …the cache file is missing. You can delete them manually from `$XDG_CACHE_HOME/zsh-snap/eval`.

### Asynchronous compilation
While you are using Zsh, Znap compiles your scripts and functions in the background, when the Zsh
Line Editor is idle. This way, your shell will start up even faster next time!

Should you not want this feature, you can disable it with `zstyle ':znap:*' auto-compile no`. Or if
you want to exclude specific files only, you can do so by passing them as absolute-path patterns to
the `auto-compile-ignore` setting. For example:
```zsh
zstyle ':znap:*' auto-compile-ignore "${ZDOTDIR:-$HOME}/.z*" '**/.editorconfig' '**.md'
```

In any case, you can compile sources manually at any time with `znap compile`.

### `znap` command
```
Usage: znap <command> [ <argument> ... ]

Commands:
  clean     remove outdated .zwc binaries from directories
  clone     make shallow git clones in parallel
  compdef   add output of command as completion function
  compile   compile asynchronously
  eval      eval (cached) output of command
  function  create lazily loaded functions
  help      print help text for command
  ignore    add local exclude patterns to repo
  install   symlink executables from repos to ~/.local/bin
  multi     run tasks in parallel
  prompt    instant prompt from repo
  pull      update repos in parallel
  restart   validate dotfiles & safely restart Zsh
  source    source plugin or repo submodules & scripts
  status    show one-line git status for each repo
  uninstall remove repo and symlinked executables

For more info on a command, type `znap help <command>`.

```

## Author
© 2020-2021 [Marlon Richert](https://github.com/marlonrichert)

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
