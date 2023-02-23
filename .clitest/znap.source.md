Initialize
```zsh
% source .clitest/__init__.zsh
% .test.setup
%
```

Znap! `source` command with no args prints usage:
```zsh
% znap source  #=> --exit 64
znap source: not enough arguments
Usage: znap source <repo> [ <dir> | <file> ] ...
Load plugins.
%
```

Sourcing a path loads its plugin file:
```zsh
% .test.makeplugin foo.plugin.zsh
% znap source foo
sourcing foo/foo.plugin.zsh...
%
```

Sourcing a repo loads its plugin file:
```zsh
% .test.reset
% .test.makeplugin bar.plugin.zsh
% znap source foo/bar
sourcing bar/bar.plugin.zsh...
%
```

Sourcing finds alternate plugin file names (`*.plugin.zsh`, `*.zsh`, `*.sh`):
```zsh
% .test.reset
% .test.makeplugin bar.plugin.zsh foo
% znap source foo
sourcing foo/bar.plugin.zsh...
% .test.reset
% .test.makeplugin bar.zsh foo
% znap source foo
sourcing foo/bar.zsh...
% .test.reset
% .test.makeplugin bar.sh foo
% znap source foo
sourcing foo/bar.sh...
%
```

Teardown
```zsh
% .test.teardown
%
```
