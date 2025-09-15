#!/usr/bin/env bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*)    os=mac;;
    MINGW*)     os=win;;
    *)          os=linux;;
esac

vimfiles=$HOME/.vim
case "${unameOut}" in
    MINGW*)     vimfiles=$HOME/vimfiles;; # Windows
esac

nvimfiles=$HOME/.config/nvim

ensure-dir() {
    local dst
    dst="$1"
    [[ ! -d "$dst" ]] && mkdir -p "$dst"
}

ensure-download() {
    local dst src dir etag
    dst="$1"
    src="$2"
    dir=$(dirname "$dst")
    if [[ -f "$dst" ]]; then
        if [[ -f "$dst.etag" ]]; then
            etag=$(cat "$dst.etag")
            curl -D headers.txt -H "If-None-Match: $etag" -fsLo "$dst" "$src"
            grep -i ETag headers.txt | awk '{print $2}' | tr -d '\r' > "$dst.etag"
            rm headers.txt
        fi
        return 0
    fi
    ensure-dir "$dir"
    if command -v curl &> /dev/null; then
        curl -D headers.txt -fsLo "$dst" "$src"
        grep -i ETag headers.txt | awk '{print $2}' | tr -d '\r' > "$dst.etag"
        rm headers.txt
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
cat "zshrc_2_fns" >> "$HOME/.zshrc"  # Custom functions must come after OS specific file for PATH to be setup


# vim
echo "... Ensure we have vim colors ..."
ensure-download "$vimfiles/colors/nord.vim" \
    "https://raw.githubusercontent.com/nordtheme/vim/refs/heads/main/colors/nord.vim"
ensure-download "$vimfiles/colors/vim-dark.vim" \
    "https://raw.githubusercontent.com/thiago-negri/vim-dark/refs/heads/main/colors/vim-dark.vim"
echo "... Ensure we have nvim colors ..."
ensure-download "$nvimfiles/colors/nord.vim" \
    "https://raw.githubusercontent.com/nordtheme/vim/refs/heads/main/colors/nord.vim"
ensure-download "$nvimfiles/colors/vim-dark.vim" \
    "https://raw.githubusercontent.com/thiago-negri/vim-dark/refs/heads/main/colors/vim-dark.vim"

# vim-plug
echo "... Ensure we have vim-plug in vim ..."
ensure-download "$vimfiles/autoload/plug.vim" \
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
echo "... Ensure we have vim-plug in nvim ..."
ensure-download "$nvimfiles/autoload/plug.vim" \
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# vimrc
echo "... Creating .vimrc ..."
cat "vimrc_0_options"  > "$vimfiles/.vimrc"
cat "vimrc_1_plugins" >> "$vimfiles/.vimrc" # Plugins go after options to make sure we have <leader> set
cat "vimrc_2_$os"     >> "$vimfiles/.vimrc"
# nvim init.lua
echo "... Creating nvim/init.lua ..."
cat "nvim_init.lua"  > "$nvimfiles/init.lua"

# vim filetypes
echo "... Creating vim ftplugin files ..."
ensure-dir "$vimfiles/ftplugin"
cp vimrc_ftplugin_gitcommit "$vimfiles/ftplugin/gitcommit.vim"

echo "DONE"
