#!/bin/bash

# Update fzf
if [ -d "$HOME/.fzf" ]; then
    git -C "$HOME/.fzf" pullf
    "$HOME/.fzf/install" --key-bindings --completion --no-update-rc
fi

