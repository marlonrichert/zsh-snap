# Znap!
Zsh-Snap –or **Znap** for short– is the light-weight plugin manager for Zsh that's easy to grok.

Consisting of only ~4 kilobytes of source code, Znap does everything you need from a
plugin manager, but without any bloat.

Znap is in fact so simple, that if you ever have a question about it, the fastest way to get an
answer is probably to [read the code](znap). Because good software shouldn't be hard to
understand.

Oh, and of course, Znap needs exactly zero configuration. Just `git clone` the repo into the
right place, `source` the plugin file, and you're good to go.

* [Installation](#installation)
* [Getting Started](#getting-started)
* [Author](#author)
* [License](#license)

# Installation
1. `cd` into the dir where you already keep your plugins or where you want to keep your plugins. If
   you don't have such a dir yet, you'll have to first make one. I personally use the following:
   ```sh
   mkdir ~/.zsh-plugins
   cd ~/.zsh-plugins
   ```
1. `git clone` this repo. You'll end up with dir called `zsh-snap` inside your plugins dir. This
   example uses `https` because you don't need a GitHub account for it, but if you do have one,
   you can use `ssh` instead:
   ```sh
   git clone https://github.com/marlonrichert/zsh-snap.git
   ```
   * _(optional)_ If you want to install Znap elsewhere, you'll need to tell it where to find your
     plugins dir (which you can also change on the fly):
     ```sh
     zstyle ':znap:*' plugins-dir ~/.zsh-plugins
     ```
1. Add this line _near the top_ of your `~/.zshrc` file —or at least early enough that Znap is
   `source`d before any plugins that you want to manage:
   ```sh
   source ~/.zsh-plugins/zsh-snap/znap.zsh
   ```
1. **Restart your shell.**

## Getting Started

`git clone` multiple repos _simultaneously,_ including submodules, straight into your plugins dir:
```sh
znap clone git@github.com:marlonrichert/zsh-hist.git https://github.com/sorin-ionescu/prezto.git
```

Instantly re-`clone` all repos you've `znap clone`d before, again _in parallel:_
```sh
znap clone
```

Run `git pull` _simultaneously_ in all your repos, including submodules, or just in specific
ones:
```sh
znap pull
znap pull zsh-autocomplete zsh-hist
```

`source` a plugin, or a combination of submodules and/or specific files inside a repo:
```sh
znap source zsh-hist
znap source ohmyzsh lib/key-bindings.zsh plugins/history-substring-search
znap source prezto modules/history modules/directory
```

Add a repo to your `$path` or `$fpath`:
```sh
typeset -gU PATH path=(
  $(znap path github-markdown-toc)
  $path
)
fpath+=( $(znap path pure) )
```

Run a command inside a repo, then **cache its output** and `eval` it with **automatic cache
invalidation:**
```sh
znap eval LS_COLORS 'gdircolors -b LS_COLORS'
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
```

…or run, cache and `eval` _without_ a repo (in which case you'll have to manually `znap rm` the
cache file when necessary):
```sh
znap eval brew-shellenv 'brew shellenv'
znap eval pyenv-init 'pyenv init -'
znap eval pipenv-completion 'pipenv --completion'
```

`rm` repos and cache files:
```sh
znap rm LS_COLORS prezto brew-shellenv
```

`cd` to your plugins dir, or straight into a repo:
```sh
znap cd
znap cd zsh-hist
```

`ls` your plugins dir, or a repo:
```sh
znap ls
znap ls zsh-hist
```

## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)

## License
This project is licensed under the MIT License. See the
[LICENSE](LICENSE) file for details.
