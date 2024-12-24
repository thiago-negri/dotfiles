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

# Setup .zshrc
[ ! -d "$HOME/.tmp" ] && mkdir $HOME/.tmp
cat zshrc > ~/.zshrc
[[ "$os" = "mac" ]] && cat zshrc_mac >> ~/.zshrc
[[ "$os" = "win" ]] && cat zshrc_win >> ~/.zshrc

# Setup .vimrc
[ ! -d "$HOME/.vim/pack" ] && mkdir -p $HOME/.vim/pack/downloads/{start,opt}
[ ! -d "$HOME/.vim/pack/downloads/opt/simple-dark" ] && git -C "$HOME/.vim/pack/downloads/opt" clone --depth 1 git@github.com:tek256/simple-dark.git
[ ! -d "$HOME/.vim/pack/downloads/opt/fzf.vim" ] && git -C "$HOME/.vim/pack/downloads/opt" clone --depth 1 git@github.com:thiago-negri/fzf.vim.git
[ ! -d "$HOME/.vim/pack/downloads/opt/lsp" ] && git -C "$HOME/.vim/pack/downloads/opt" clone --depth 1 git@github.com:yegappan/lsp.git
[ ! -d "$HOME/.vim/pack/downloads/opt/vim-highlightedyank" ] && git -C "$HOME/.vim/pack/downloads/opt" clone --depth 1 git@github.com:machakann/vim-highlightedyank.git
[ ! -d "$HOME/.vim/pack/downloads/opt/vim-vinegar" ] && git -C "$HOME/.vim/pack/downloads/opt" clone --depth 1 git@github.com:tpope/vim-vinegar.git
[ ! -d "$HOME/.vim/pack/downloads/opt/vim-commentary" ] && git -C "$HOME/.vim/pack/downloads/opt" clone --depth 1 git@github.com:tpope/vim-commentary.git
[ ! -d "$HOME/.vim/pack/downloads/opt/vim-easymotion" ] && git -C "$HOME/.vim/pack/downloads/opt" clone --depth 1 git@github.com:easymotion/vim-easymotion.git
[ ! -d "$HOME/.vim/pack/downloads/opt/vim-sleuth" ] && git -C "$HOME/.vim/pack/downloads/opt" clone --depth 1 git@github.com:tpope/vim-sleuth.git
cat vimrc >> ~/.vimrc
[[ "$os" = "mac" ]] && cat vimrc_mac >> ~/.vimrc
[[ "$os" = "win" ]] && cat vimrc_win >> ~/.vimrc

# Install LSPs
[ ! -d "$HOME/.vim/lsps" ] && mkdir -p $HOME/.vim/lsps
cd $HOME/.vim/lsps
[ ! -d "$HOME/.vim/lsps/node_modules/typescript-language-server" ] && npm i typescript-language-server

