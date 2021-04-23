#!/bin/zsh
FPATH=$FPATH:${0:h}/functions zsh ~[clitest]/clitest \
    --list-run --progress dot --prompt '%' --pre-flight ". ${0:h}/.znap.opts.zsh" \
    -- ${0:h}/.clitest/*.md
