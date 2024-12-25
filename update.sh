#!/bin/bash

# Update fzf
if [ -d "$HOME/.fzf" ]; then
    cd ~/.fzf
    git pullf
    cd - >/dev/null
    ~/.fzf/install --key-bindings --completion --no-update-rc
fi

