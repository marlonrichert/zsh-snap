# ⚡️Znap!
**Znap** is the light-weight Git repo manager for Zsh that's easy to grok. While tailored to
managing Zsh plugins and dotfiles specifically, Znap also makes it easier to work with multiple Git
repos in general.

> Enjoy using this software? [Become a sponsor!](https://github.com/sponsors/marlonrichert)

## Installation
Just copy-paste the following into your command line and press <kbd>Enter</kbd>:
```zsh
git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git
source zsh-snap/install.zsh
```

### Requirements

Recommended:
* Zsh 5.7.1 or newer
* Git 2.8 or newer

Minimum:
* Zsh 5.4.2

### Updating
To update Znap and all of your plugins/repos simultaneously, run
```zsh
% znap pull
```

## Dotfiles Usage
Using Znap to manage your plugins can be as simple as putting this in your `.zshrc` file:
```zsh
# Download Znap, if it's not there yet.
[[ -f ~/Git/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Git/zsh-snap

source ~/Git/zsh-snap/znap.zsh  # Start Znap

# `znap prompt` makes your prompt visible in just 15-40ms!
znap prompt sindresorhus/pure

# `znap source` automatically downloads and starts your plugins.
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting

# `znap eval` caches and runs any kind of command output for you.
znap eval iterm2 'curl -fsSL https://iterm2.com/shell_integration/zsh'

# `znap function` lets you lazy-load features you don't always need.
znap function _pyenv pyenvn 'eval "$( pyenv init - --no-rehash )"'
compctl -K    _pyenv pyenv
```

For more examples of what Znap can do for your dotfiles, please see [the included `.zshrc`
file](.zshrc).

Additionaly, Znap makes it so that you actually need to have _less_ in your `.zshrc` file, by
automating several tasks for you.

### Automatic `compinit` and `bashcompinit`
Note that the above example does not include any call to
[`complist`](http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fcomplist-Module),
[`compinit`, or
`bashcompinit`](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Initialization) in
the `.zshrc` file. That is because Znap will run these for you as needed.

### Asynchronous compilation
Znap compiles your scripts and functions in the background. This way, your shell will start up even
faster next time!

Should you not want this feature, you can disable it with
```zsh
zstyle ':znap:*' auto-compile no
```

In any case, you can compile sources manually at any time with
`znap compile [ <dir> | <file> ] ...`.

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

### Automatic `git maintenance`
When using `git` 2.31.0 or newer, Znap automatically enables `git maintenance` in each repo that it
manages. This automatically optimizes your repos in the background, so that your `git` and `znap`
commands will run faster.

To selectively disable this feature, add
```zsh
zstyle ':znap:*:<glob pattern>' git-maintenance off
```
to your `.zshrc` file. Next time you run `znap pull`, `git maintenance` will then be disabled for
each repo whose name matches `<glob pattern>`.

Use `*` as your [glob
pattern](https://zsh.sourceforge.io/Doc/Release/Expansion.html#Filename-Generation) to opt out of
this feature completely.

## Command-Line Usage
Znap also makes life on the command line easier. For a full list of available commands, just run
```zsh
% znap
```
Exhaustive tab-completion is available, too. For examples of the most important command-line
features, see below.

> Note:
> * The examples in this section you should run on the command line, not add to your `.zshrc`
>   file!
> * `%` represents the prompt. You shouldn't type that part. 🙂

### Install executables and completion functions
Znap can download multiple repos in parallel, then automatically find and install their
executables and completion functions, with just one command:
```zsh
% znap install asdf-vm/asdf aureliojargas/clitest bigH/git-fuzzy \
    ekalinin/github-markdown-toc ohmyzsh/ohmyzsh zsh-users/zsh-completions
```

To remove these (and their repos), use `znap uninstall`:
```zsh
% znap uninstall asdf clitest git-fuzzy \
    github-markdown-toc ohmyzsh zsh-completions
```

Executables are installed in `~/.local/bin`, while completion functions go to
`${XDG_DATA_HOME:-~/.local/share}/zsh/site-functions`.

### Install generated functions
Some commands generate output that should be loaded as a function. You can install these generated
functions as follows:
```zsh
% znap fpath _kubectl 'kubectl completion  zsh'
% znap fpath _rustup  'rustup  completions zsh'
% znap fpath _cargo   'rustup  completions zsh cargo'
```

These functions, too, are saved to `${XDG_DATA_HOME:-~/.local/share}/zsh/site-functions`.

### Named dirs
Znap makes your repos dir and all of its subdirs available as [named
directories](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Filename-Expansion):
```zsh
% cd ~znap                  # `cd` to your repos dir
% cd ~[github-markdown-toc] # `cd` to a repo
% ls ~[asdf]/completions    # `ls` a subdir in a repo
```

## Author
© 2020-2021 [Marlon Richert](https://github.com/marlonrichert)

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
