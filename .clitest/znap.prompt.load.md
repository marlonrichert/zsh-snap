Setup
```zsh
% autoload -Uz .znap.prompt.load
% fpath_=( "$fpath[@]" )
%
```

Function is already loaded:
```zsh
% prompt_bar_setup() { TEST }
% .znap.prompt.load foo bar; print $?; type -f prompt_bar_setup
0
prompt_bar_setup () {
	TEST
}
% unfunction prompt_bar_setup
% fpath=( "$fpath_[@]" )
%
```

Function can be autoloaded from `$fpath`:
```zsh
% dir=$(mktemp -d)
% print TEST > $dir/prompt_bar_setup
% fpath+=( $dir )
% .znap.prompt.load $dir/foo bar; print $?; type -f prompt_bar_setup
0
prompt_bar_setup () {
	TEST
}
% unfunction prompt_bar_setup
% fpath=( "$fpath_[@]" )
%
```

Function can be found in repo and autoloaded:
```zsh
% dir=$(mktemp -d)
% mkdir -p $dir/foo/baz
% print TEST > $dir/foo/baz/prompt_bar_setup
% .znap.prompt.load $dir/foo bar; print $?; type -f prompt_bar_setup
0
prompt_bar_setup () {
	TEST
}
% unfunction prompt_bar_setup
% fpath=( "$fpath_[@]" )
%
```

Function can be found in repo and autoloaded:
```zsh
% dir=$(mktemp -d)
% mkdir -p $dir/foo/baz
% print TEST > $dir/foo/baz/prompt_bar_setup
% .znap.prompt.load $dir/foo bar; print $?; type -f prompt_bar_setup
0
prompt_bar_setup () {
	TEST
}
% unfunction prompt_bar_setup
% fpath=( "$fpath_[@]" )
%
```

Theme file can be found in repo and wrapper function is created:
```zsh
% dir=$(mktemp -d)
% mkdir -p $dir/foo/baz
% print TEST > $dir/foo/baz/bar.zsh-theme
% .znap.prompt.load $dir/foo bar; print $?; print ${+functions[prompt_bar_setup]}
0
1
% unfunction prompt_bar_setup
% fpath=( "$fpath_[@]" )
%
```
