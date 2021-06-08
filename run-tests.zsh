#!/bin/zsh -f
print $OSTYPE $SHELL $ZSH_VERSION $ZSH_PATCHLEVEL
FPATH=$FPATH:${0:h}/functions zsh -f -- =clitest \
    --list-run --progress dot --prompt '%' --pre-flight ". ${0:h}/.znap.opts.zsh" \
    -- ${0:h}/.clitest/*.md
