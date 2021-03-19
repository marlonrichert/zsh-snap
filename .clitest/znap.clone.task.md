Setup:
```zsh
% autoload -Uz .znap.clone.task
% git() { print $@[-1] }
% .znap.compile() { print ${(D)1} }
% hash -d znap=$(mktemp -d)
%
```

If the repo is specified as "user/repo", it is cloned from the given server:
```zsh
% .znap.clone.task TEST@TEST.TEST: foo/bar
TEST@TEST.TEST:foo/bar.git
~znap/bar
% .znap.clone.task TEST://TEST.TEST/ foo/bar
TEST://TEST.TEST/foo/bar.git
~znap/bar
%
```

If the repo is specified as a full URL, the server is ignored:
```zsh
% .znap.clone.task IGNORED TEST@TEST.TEST:foo/bar.git
TEST@TEST.TEST:foo/bar.git
~znap/bar
% .znap.clone.task IGNORED TEST://TEST.TEST/foo/bar.git
TEST://TEST.TEST/foo/bar.git
~znap/bar
%
```

If the repo already exists, nothing happens:
```
% mkdir -p ~znap/bar
% .znap.clone.task TEST@TEST.TEST: foo/bar
% .znap.clone.task TEST://TEST.TEST/ foo/bar
%
```
