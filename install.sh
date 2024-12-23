#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*)    os=mac;;
    MINGW*)     os=win;;
    *)          os=linux;;
esac

# Install fzf
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc
fi

# Install vim-plug
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Setup .zshrc
# TODO: Preprocess files so they don't need to if/else on OS
cp zshrc ~/.zshrc

# Setup .vimrc
if [[ "$os" -eq "mac" ]]; then
    echo "language en_US.UTF-8" > ~/.vimrc
fi

if [[ "$os" -eq "win" ]]; then
    echo "language en_US.utf8" > ~/.vimrc
fi
echo "" > ~/.vimrc

cat vimrc >> ~/.vimrc

