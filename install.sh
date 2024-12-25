#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*)    os=mac;;
    MINGW*)     os=win;;
    *)          os=linux;;
esac

# Install fzf
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 git@github.com:junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc
fi

# Setup zsh
[ ! -d "$HOME/.tmp" ] && mkdir $HOME/.tmp
cat zshrc > ~/.zshrc
[[ "$os" = "mac" ]] && cat zshrc_mac >> ~/.zshrc
[[ "$os" = "win" ]] && cat zshrc_win >> ~/.zshrc

# Setup vim
[ ! -d "$HOME/.vim/pack" ] && mkdir -p $HOME/.vim/pack/downloads/{start,opt}
cd "$HOME/.vim/pack/downloads/opt"
[ ! -d "./fzf.vim" ]             && git clone --depth 1 git@github.com:thiago-negri/fzf.vim.git
[ ! -d "./lsp" ]                 && git clone --depth 1 git@github.com:yegappan/lsp.git
[ ! -d "./vim-dark" ]            && git clone --depth 1 git@github.com:thiago-negri/vim-dark.git
[ ! -d "./vim-commentary" ]      && git clone --depth 1 git@github.com:tpope/vim-commentary.git
[ ! -d "./vim-easymotion" ]      && git clone --depth 1 git@github.com:easymotion/vim-easymotion.git
[ ! -d "./vim-fugitive" ]        && git clone --depth 1 git@github.com:tpope/vim-fugitive.git
[ ! -d "./vim-graphql" ]         && git clone --depth 1 git@github.com:jparise/vim-graphql.git
[ ! -d "./vim-highlightedyank" ] && git clone --depth 1 git@github.com:machakann/vim-highlightedyank.git
[ ! -d "./vim-sleuth" ]          && git clone --depth 1 git@github.com:tpope/vim-sleuth.git
[ ! -d "./vim-vinegar" ]         && git clone --depth 1 git@github.com:tpope/vim-vinegar.git
cd - >/dev/null
cat vimrc > ~/.vimrc
[[ "$os" = "mac" ]] && cat vimrc_mac >> ~/.vimrc
[[ "$os" = "win" ]] && cat vimrc_win >> ~/.vimrc

# Install vim LSPs
[ ! -d "$HOME/.vim/lsps" ] && mkdir -p $HOME/.vim/lsps
cd $HOME/.vim/lsps
[ ! -d "./node_modules/typescript-language-server" ] && npm i typescript-language-server
cd - >/dev/null

