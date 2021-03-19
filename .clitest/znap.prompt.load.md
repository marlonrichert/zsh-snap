Setup
```zsh
% autoload -Uz .znap.prompt.load
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
%
```

Function can be autoloaded directly:
```zsh
% dir=$(mktemp -d)
% print TEST > $dir/prompt_bar_setup
% fpath+=( $dir )
% .znap.prompt.load foo bar; print $?; type -f prompt_bar_setup
0
prompt_bar_setup () {
	TEST
}
% unfunction prompt_bar_setup
%
```

Function can be found in repo and autoloaded:
```zsh
% dir=$(mktemp -d)
% mkdir -p $dir/foo/baz
% print TEST > $dir/foo/baz/prompt_bar_setup
% .znap.prompt.load foo bar; print $?; type -f prompt_bar_setup
0
prompt_bar_setup () {
	TEST
}
% unfunction prompt_bar_setup
%
```

Function can be found in repo and autoloaded:
```zsh
% dir=$(mktemp -d)
% mkdir -p $dir/foo/baz
% print TEST > $dir/foo/baz/prompt_bar_setup
% .znap.prompt.load foo bar; print $?; type -f prompt_bar_setup
0
prompt_bar_setup () {
	TEST
}
% unfunction prompt_bar_setup
%
```

Theme file can be found in repo and wrapper function is created:
```zsh
% dir=$(mktemp -d)
% mkdir -p $dir/foo/baz
% print TEST > $dir/foo/baz/bar.zsh-theme
% .znap.prompt.load foo bar; print $?; type -f prompt_bar_setup
0
prompt_bar_setup () {
	TEST
}
% unfunction prompt_bar_setup
%
```
