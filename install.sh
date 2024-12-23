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
[[ "$os" = "mac" ]] && cat zshrc.mac > ~/.zshrc
[[ "$os" = "win" ]] && cat zshrc.win > ~/.zshrc
cat zshrc >> ~/.zshrc

# Setup .vimrc
[[ "$os" = "mac" ]] && cat vimrc.mac > ~/.vimrc
[[ "$os" = "win" ]] && cat vimrc.win > ~/.vimrc
cat vimrc >> ~/.vimrc

