#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*)    os=mac;;
    MINGW*)     os=win;;
    *)          os=linux;;
esac

cat zshrc > $HOME/.zshrc
[[ "$os" = "mac" ]] && cat zshrc_mac >> $HOME/.zshrc
[[ "$os" = "win" ]] && cat zshrc_win >> $HOME/.zshrc


