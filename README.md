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

## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)

## License
This project is licensed under the MIT License. See the
[LICENSE](LICENSE) file for details.
