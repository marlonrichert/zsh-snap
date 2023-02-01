#!/usr/bin/env zsh
cd ${0:A:h}
env -i HOME=$( mktemp -d ) PATH=$PATH FPATH=$FPATH zsh -f -- \
    =clitest \
        --list-run --progress dot --prompt '%' \
        --color always \
        --pre-flight 'git --version; print $PWD $VENDOR $OSTYPE =zsh $ZSH_VERSION $ZSH_PATCHLEVEL' \
        -- $PWD/.clitest/*.md
