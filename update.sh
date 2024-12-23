#!/bin/bash

# Update fzf
if [ -d "$HOME/.fzf" ]; then
    cd ~/.fzf
    git pullf
    cd -
    ~/.fzf/install --key-bindings --completion --no-update-rc
fi

# Update vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

