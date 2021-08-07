Setup:
```zsh
% autoload -Uz .znap.clone.task
% git() { if [[ $1 == --version ]]; then print 2.8.0; else print $@[-1]; fi }
% .znap.ignore() { : }
% hash -d znap=$(mktemp -d)
%
```

If the repo is specified as "user/repo", it is cloned from the given server:
```zsh
% .znap.clone.task TEST@TEST.TEST: foo/bar
TEST@TEST.TEST:foo/bar.git
% .znap.clone.task TEST://TEST.TEST/ foo/bar
TEST://TEST.TEST/foo/bar.git
%
```

If the repo is specified as a full URL, the server is ignored:
```zsh
% .znap.clone.task IGNORED TEST@TEST.TEST:foo/bar.git
TEST@TEST.TEST:foo/bar.git
% .znap.clone.task IGNORED TEST://TEST.TEST/foo/bar.git
TEST://TEST.TEST/foo/bar.git
%
```

If the repo already exists, nothing happens:
```
% mkdir -p ~znap/bar
% .znap.clone.task TEST@TEST.TEST: foo/bar
% .znap.clone.task TEST://TEST.TEST/ foo/bar
%
```
