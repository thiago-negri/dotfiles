#!/usr/bin/env bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*)    os=mac;;
    MINGW*)     os=win;;
    *)          os=linux;;
esac
case "${unameOut}" in
    Darwin*)    vimfiles=$HOME/.vim;;
    MINGW*)     vimfiles=$HOME/vimfiles;; # Windows
    *)          vimfiles=$HOME/.vim;;
esac

ensure-dir() {
    local dst="$1"
    [[ ! -d "$dst" ]] && mkdir -p "$dst"
}

ensure-download() {
    local dst="$1"
    local src="$2"
    local dir=$(dirname "$dst")
    if [[ -f "$dst" ]]; then
        return 0
    fi
    ensure-dir "$dir"
    if command -v curl &> /dev/null; then
        curl -fLo "$dst" "$src"
        return 0
    fi
    if command -v wget &> /dev/null; then
        wget "$src" -O "$dst"
        return 0
    fi
    echo "ERROR wget|curl not found"
    return 1
}


# gg
echo "... Ensure we have GG ..."
if [[ ! -d "$HOME/.gg" ]]; then
    git clone git@github.com:thiago-negri/gg.git "$HOME/.gg"
fi


# fzf
if [[ ! -d "$HOME/.fzf" ]]; then
    printf "... Installing FZF ...\n\n"
    git clone --depth 1 git@github.com:junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --key-bindings --completion --no-update-rc
    printf "\n"
else
    printf "... Updating FZF ..."
    git_result=$(git -C "$HOME/.fzf" pullf)
    if [[ "Already up to date." = "$git_result" ]]; then
        printf " It's up to date.\n"
    else
        printf " Found update, running install script ...\n\n"
        "$HOME/.fzf/install" --key-bindings --completion --no-update-rc
        printf "\n"
    fi
fi


# zsh
echo "... Creating .zshrc ..."
ensure-dir "$HOME/.tmp"
cat "zshrc_0"      > "$HOME/.zshrc"
cat "zshrc_1_$os" >> "$HOME/.zshrc"
cat "zshrc_2_git" >> "$HOME/.zshrc"


# vim
echo "... Ensure we have vim colors ..."
ensure-download "$vimfiles/colors/nord.vim" \
    "https://raw.githubusercontent.com/nordtheme/vim/refs/heads/main/colors/nord.vim"
ensure-download "$vimfiles/autoload/lightline/colorscheme/nord.vim" \
    "https://raw.githubusercontent.com/nordtheme/vim/refs/heads/main/autoload/lightline/colorscheme/nord.vim"

# vim-plug
echo "... Ensure we have vim-plug ..."
ensure-download "$vimfiles/autoload/plug.vim" \
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# vimrc
echo "... Creating .vimrc ..."
cat "vimrc_0_options"  > "$HOME/.vimrc"
cat "vimrc_1_plugins" >> "$HOME/.vimrc" # Plugins go after options to make sure we have <leader> set
cat "vimrc_2_$os"     >> "$HOME/.vimrc"

# vim filetypes
echo "... Creating vim ftplugin files ..."
ensure-dir "$vimfiles/ftplugin"
cp vimrc_ftplugin_gitcommit "$vimfiles/ftplugin/gitcommit.vim"

echo "DONE"
