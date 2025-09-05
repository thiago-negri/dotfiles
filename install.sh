#!/usr/bin/env bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*)    os=mac;;
    MINGW*)     os=win;;
    *)          os=linux;;
esac

# fzf
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 git@github.com:junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install --key-bindings --completion --no-update-rc
fi


# zsh
[ ! -d "$HOME/.tmp" ] && mkdir "$HOME/.tmp"
cat zshrc > $HOME/.zshrc
[[ "$os" = "mac" ]]   && cat zshrc_mac   >> "$HOME/.zshrc"
[[ "$os" = "win" ]]   && cat zshrc_win   >> "$HOME/.zshrc"
[[ "$os" = "linux" ]] && cat zshrc_linux >> "$HOME/.zshrc"


# vim
[ ! -d "$HOME/.vim/colors" ] && mkdir -p "$HOME/.vim/colors"
wget "https://raw.githubusercontent.com/nordtheme/vim/refs/heads/main/colors/nord.vim" -O "$HOME/.vim/colors/nord.vim"

# vimrc
cat vimrc > "$HOME/.vimrc"
[[ "$os" = "mac" ]]   && cat vimrc_mac   >> "$HOME/.vimrc"
[[ "$os" = "win" ]]   && cat vimrc_win   >> "$HOME/.vimrc"
[[ "$os" = "linux" ]] && cat vimrc_linux >> "$HOME/.vimrc"

# vim filetypes
[ ! -d "$HOME/.vim/ftplugin" ] && mkdir -p "$HOME/.vim/ftplugin"
cp vimrc_gitcommit "$HOME/.vim/ftplugin/gitcommit.vim"

