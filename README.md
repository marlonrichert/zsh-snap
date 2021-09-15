# ⚡️Znap!
**Znap** is the light-weight Git repo manager for Zsh that's easy to grok. While tailored to
managing Zsh plugins and dotfiles specifically, Znap also makes it easier to work with multiple Git
repos in general.

> Enjoy using this software? [Become a sponsor!](https://github.com/sponsors/marlonrichert)

## Installation
To use Znap to manage your existing (plugin) repos, just copy-paste the following into your command
line and press <kbd>Enter</kbd>:
```zsh
git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git
source zsh-snap/install.zsh
```

### Requirements

Recommended:
* Zsh 5.7.1 or newer
* Git 2.8.0 or newer

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
    git clone https://github.com/marlonrichert/zsh-snap.git ~/Git/zsh-snap

source ~/Git/zsh-snap/znap.zsh  # Start Znap

# `znap prompt` makes your prompt visible in less than 12ms!
znap prompt sindresorhus/pure

# `znap source` automatically downloads and installs your plugins.
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting

# `znap eval` caches any kind of command output for you.
znap eval iterm2 'curl -fsSL https://iterm2.com/shell_integration/zsh'
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
your `.zshrc` file. That is because Znap will run these for you as needed.

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

Should you not want this feature, you can disable it with
```zsh
zstyle ':znap:*' auto-compile no
```
Alternatively, if you want to exclude specific files only, you can do so by passing them as
absolute-path patterns to the `auto-compile-ignore` setting. For example:
```zsh
zstyle ':znap:*' auto-compile-ignore "${ZDOTDIR:-$HOME}/.z*" '**/.editorconfig' '**.md'
```

In any case, you can compile sources manually at any time with `znap compile`.

## Command-Line Usage
Znap also makes life on the command line easier. For a full list of available commands, run
```zsh
% znap
```
Exhaustive tab-completion is available, too.

> Note 1: The examples in this section you should run on the command line, not add to your `.zshrc`
file!
> Note 2: `%` represents the prompt. You shouldn't type that part. 🙂

Below are examples of the most important command-line features that Znap makes available.

### Named dirs
Znap makes your repos dir and all of its subdirs available as [named
directories](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Filename-Expansion):
```zsh
% cd ~znap                  # `cd` to your repos dir
% cd ~[github-markdown-toc] # `cd` to a repo
% ls ~[asdf]/completions    # `ls` a subdir in a repo
```

### Installing executables and completion functions
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

Executables are installed in `~/.local/bin`, while completion functions go into
`${XDG_DATA_HOME:-~/.local/share}/zsh/site-functions`.

### Installing generated functions
Some commands generate output that should be loaded as a function. You can install these generated
functions as follows:
```zsh
% znap fpath _kubectl 'kubectl completion  zsh'
% znap fpath _rustup  'rustup  completions zsh'
% znap fpath _cargo   'rustup  completions zsh cargo'
```

## Author
© 2020-2021 [Marlon Richert](https://github.com/marlonrichert)

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
